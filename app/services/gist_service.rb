class GistService
  def initialize(gist_id)
    @gist_id = gist_id
    @client = Octokit::Client.new
  end
  
  def call
    begin
      files = @client.gist(@gist_id)[:files]

      content = ''

      files.each do |filename|
        content << filename.last[:content]
        content << "\n"
      end

      content
    rescue Octokit::NotFound => e
      puts "Gist with id '#{gist_id}' not found."
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end
