# frozen_string_literal: true

module CamdramInteroperability
  extend ActiveSupport::Concern

  included do
    after_create_commit :warm_cache!
    validates :camdram_id, numericality: { only_integer: true,
      greater_than: 0 }, uniqueness: { message: 'entity already exists' }
  end

  module ClassMethods
    # Creates a CamdramEntity model from a Camdram::Base object.
    def create_from_camdram(camdram_base)
      create_from_id(camdram_base.id)
    end

    # Find a CamdramEntity model from a Camdram::Base object.
    def find_from_camdram(camdram_base)
      find_by(camdram_id: camdram_base.id)
    end
  end

  # Returns the name of the entity by querying the Camdram API. This method
  # gets called quite a lot so let's cache the result indefinitely to avoid
  # instantiating a Camdram object each time. The cache can then be refreshed
  # by a background job.
  def name(refresh_cache: false)
    Rails.cache.fetch("#{cache_key}/name", expires_in: nil, force: refresh_cache) do
      camdram_object.name
    end
  end

  # Returns the entity's external URL on Camdram.
  def url
    Roombooking::CamdramAPI.url_for(camdram_object)
  end

  # Queues a background job to refresh the entity's cached data from Camdram.
  def warm_cache!
    global_id = self.to_global_id.to_s
    CamdramEntityCacheWarmupJob.perform_async(global_id)
  end
end
