class PublishedGene < ActiveRecord::Base
  belongs_to :article
  belongs_to :gene
end
