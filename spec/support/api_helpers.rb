module ApiHelpers
  def api_response_json
    @api_response_json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {} )
    send method, path, options
  end
end
