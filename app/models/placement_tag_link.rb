class PlacementTagLink < ActiveRecord::Base
  belongs_to :placement
  belongs_to :tag
end
