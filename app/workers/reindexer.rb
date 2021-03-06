# handles reindexing of models or objects
class Reindexer
  @queue = :reindex
  @slack = Slack::Notifier.new Rails.application.secrets.slack_worker_webhook

  REINDEX_BATCH_SIZE = 10_000

  def self.perform(model, ids = [])
    @model = model
    start_time = Time.now
    ids.any? ? reindex_objects(ids) : reindex_model
    end_time = Time.now
    end_message = "Reindexing of `#{model}` complete! Job took #{end_time - start_time} seconds."
    notify end_message
  end

  def self.reindex_model
    notify "Reindexing all `#{@model}` objects."
    @model.constantize.find_in_batches(batch_size: REINDEX_BATCH_SIZE) do |batch|
      retries = 3
      begin
        Sunspot.index batch
      rescue Net::ReadTimeout => e
        raise(e) if retries == 0

        @slack.ping "Retrying batch index due to timeout (retry #{i})"
        retries -= 1
        retry
      end
    end
    Sunspot.commit
  rescue StandardError => e
    notify "Reindexing failed for model `#{@model}`: ```#{e}```"
  end

  def self.reindex_objects(object_ids)
    notify "Reindexing selected objects from `#{@model}`."
    @model.constantize.where(id: object_ids).find_in_batches(batch_size: REINDEX_BATCH_SIZE) do |batch|
      Sunspot.index! batch
    end
  rescue StandardError => e
    notify "Reindexing failed for model `#{@model}` with object_ids: ```#{e}```"
  end

  def self.notify(message)
    @slack.ping(message) if Rails.env.production? || Rails.env.staging?
  end

end