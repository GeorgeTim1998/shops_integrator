ActiveModelSerializers.config.adapter = :json

class BuySerializer < ActiveModel::Serializer
  type :data
  attribute :amount_due
  attribute :bonuses, key: 'remaining_bonus'

  def amount_due
    @instance_options[:amount_due]
  end
end
