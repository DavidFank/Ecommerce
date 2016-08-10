class Order < ActiveRecord::Base
	has_many :lineitems
	belongs_to :user

	serialize :order_items, Hash 
end
