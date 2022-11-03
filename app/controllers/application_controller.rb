class ApplicationController < ActionController::API
  def error_renderer(errors)
    data = { errors: [] }
    errors.each do |error|
      data[:errors] << error_body(error).merge(meta: error_meta(error))
    end
    data
  end

  def buy_error
    {
      success: false,
      errors: {
        amount: ['is required'],
        user_id: ['is required']
      }
    }
  end

  def buy_success(card, amount_due)
    {
      success: true,
      data: {
        amount_due:,
        remaining_bonus: card.bonuses
      }
    }
  end

  private

  def error_body(error)
    error_body = I18n.t(:errors)[error.type][:body]
    {
      code: error_body[:code],
      status: error_body[:status],
      title: error_body[:title],
      detail: error_body[:detail].sub('resource', error.attribute.to_s.capitalize),
      source: {
        pointer: "/data/attributes/#{error.attribute}"
      }
    }
  end

  def error_meta(error)
    error_meta = I18n.t(:errors)[error.type][:meta]
    {
      attribute: error.attribute,
      message: error_meta[:message],
      code: error.type
    }
  end
end
