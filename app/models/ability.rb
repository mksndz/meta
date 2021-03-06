class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    roles = user.roles

    if roles.include? 'super'

      can :manage, :all

    else

      if roles.include? 'coordinator'

        # User with Coordinator Role can create new Users
        can [:new, :create], User

        # can also manage Users they created
        can [:index, :show, :edit, :update, :destroy], User, creator_id: user.id

        can [:show, :edit, :update, :destroy], Batch do |batch|
          user.manages? batch.user
        end

        can [:index, :new, :create], :invitation

      end

      if roles.include? 'committer'

        # User with Committer Role can commit their own Batches
        can [:commit, :commit_form], Batch, user_id: user.id

        # User with Committer Role can view results of any commit
        can [:results], Batch

      end

      if roles.include? 'uploader'

        can [:new, :create, :help], BatchImport
        can [:index, :show, :xml, :destroy], BatchImport, batch: { user_id: user.id }

      end

      if roles.include? 'viewer'

        can [:index, :show], Item
        can [:index, :show], Collection
        can [:index, :show], Repository

      end

      can(:manage, Project) if roles.include? 'pm'
      can(:manage, FulltextIngest) if roles.include? 'fulltext ingester'
      can(:manage, PageIngest) if roles.include? 'page ingester'

      if roles.include?('committer') && roles.include?('coordinator')

        can [:commit], Batch do |batch|
          user.manages? batch.user
        end

      end

    end

    can [:index, :show, :new, :create, :edit, :update], Repository do |repository|
      user.repositories.include?(repository)
    end

    can [:index, :show, :create, :edit, :update], Collection do |collection|
      user.repositories.include?(collection.repository) ||
          user.collections.include?(collection)
    end

    can :xml, Item
    can [:index, :show, :new, :create, :edit, :update, :copy], Item do |item|
      user.repositories.include?(item.repository) ||
          user.collections.include?(item.collection)
    end

    can [:rollback, :restore, :diff], ItemVersion do |item_version|
      collection_id = item_version.object['collection_id']
      collection = Collection.find collection_id
      return false unless collection
      user.collections.include?(collection) ||
        user.repositories.include?(collection.repository)
    end

    can [:show, :edit, :update, :destroy, :recreate], Batch, user_id: user.id
    can [:index, :new, :create], Batch


    can [:index, :new, :create], BatchItem

    can [:show, :edit, :update], BatchItem do |batch_item|
      if batch_item.persisted?
        user.repositories.include?(batch_item.collection.repository) ||
          user.collections.include?(batch_item.collection)
      else
        false
      end
    end

    can [:index, :show], HoldingInstitution
    can [:index, :show], Project

    can [:show, :edit, :create, :update, :destroy], BatchItem, { batch: { user_id: user.id }  }

    can :manage, :advanced
    can :manage, :catalog
    can :manage, :bookmarks
    can :manage, :profile

  end

end

