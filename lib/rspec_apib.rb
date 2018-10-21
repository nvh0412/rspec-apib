require "rspec_apib/version"
require "rspec_apib/string_extensions"

RSpec.configure do |config|
  config.before(:suite) do |example|
    api_docs_folder_path = File.join(Dir.pwd, '/api_docs/')
    Dir.mkdir(api_docs_folder_path) unless Dir.exists?(api_docs_folder_path)
  end

  config.after(:each, type: :controller) do |example|
    response ||= last_response
    request ||= last_request

    if response
      example_group = example.metadata[:example_group]
      example_groups = []

      while example_group
        example_groups << example_group
        example_group = example_group[:parent_example_group]
      end

      action = example_groups[-2][:description_args].first if example_groups[-2]
      example_groups[-1][:description_args].first.match(/(\w+)\sRequests/)

      file_name = 'api'
      file = File.join(Dir.pwd, "/api_docs/#{file_name}.apib")

      File.open(file, 'a') do |f|
        # Resource & Action
        f.write "### #{action}\n\n" if [200, 201].include?(response.status)

        # Request
        request_body = request.body.read
        authorization_header = request.env ? request.env['HTTP_EH_AUTH'] : request.headers['HTTP_EH_AUTH']

        if request_body.present? || authorization_header.present?
          f.write "+ Request (#{request.content_type})\n\n"

          # Request Headers
          if authorization_header.present?
            f.write "+ Headers\n".indent(2)
            f.write "HTTP_EH_AUTH: #{authorization_header}\n".indent(4)
          end

          f.write "\n"

          # Request Body
          if request_body.present? && request.content_type == 'application/json'
            f.write "+ Body\n".indent(2) if authorization_header
            f.write "#{JSON.pretty_generate(JSON.parse(request_body))}\n".indent(4)
            f.write "\n"
          end
        end if [200, 201].include?(response.status)

        # Response
        f.write "+ Response #{response.status} (#{response.content_type})\n\n"

        if response.body.present? && response.content_type =~ /application\/json/
          f.write "+ Body\n".indent(2)
          f.write "#{JSON.pretty_generate(JSON.parse(response.body))}\n".indent(4)
          f.write "\n"
        end
      end
    end
  end
end
