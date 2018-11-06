class Session < Struct.new(:name)
  include ActiveModel::Model
end
