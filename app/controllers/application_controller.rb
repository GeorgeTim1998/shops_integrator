class ApplicationController < ActionController::API
  def error_renderer(errors)
    data = { errors: [] }
    errors.each do |error|
      data[:errors] << error_body(error).merge(meta: error_meta(error))
    end
    data
  end

  def validate_params
    errors = {}

    if Integer(params[:user_id], exception: false).nil? || User.find_by(id: params[:user_id]).nil?
      errors.merge!(user_id: ['is required'])
    end

    if Float(params[:amount], exception: false).nil?
      errors.merge!(amount: ['is required'])
    else
      errors.merge!(amount: ['must be greater than 0']) unless params[:amount].positive?
    end

    render json: { success: false }.merge(errors:), status: :unprocessable_entity unless errors.empty?
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
