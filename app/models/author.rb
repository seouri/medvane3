class Author < ActiveRecord::Base
  has_many :authorships
  has_many :articles, :through => :authorships
  
  validates_uniqueness_of :fore_name, :scope => :last_name
  
  def full_name
    #{last_name initials}
  end
end
