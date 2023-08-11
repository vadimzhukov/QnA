module ApiHelpers
  def api_response_json
    @api_response_json ||= JSON.parse(response.body)
  end
end