require 'rubygems'
require 'httparty'

class WebTrends
  include HTTParty

  APIVERSION = 'v1'
  
  default_params :dcsformat => 'xml'
  format :xml
  base_uri "http://dc.webtrends.com/#{APIVERSION}"
  
  def initialize(options={})
    @dcsid   = options[:dcsid] || "dcslbiart00000gwngvpqkrcn_2u3z"
    @verbose = options[:verbose] || false
  end

  def get_visitor_identifier
    self.class.post("/#{@dcsid}/ids.svc", :body=>extra_params)['id']
  end

  def post_event(visitor_id, event={})
    body = {
      :dcsuri    => '/MyRubyTest',
      :dcssip    => 'localhost',
      :'WT.ti'   => 'My Ruby Test',
      :'WT.co_f' => visitor_id
    }.merge(extra_params).merge(event)
    self.class.post("/#{@dcsid}/events.svc", :body=>body)
  end
  
private 

  def self.verbose?
    @verbose
  end

  def extra_params
    @verbose ? {:dcsverbose=>true} : {}
  end

end

client = WebTrends.new(:verbose=>true)
puts "* Getting visitor ID..."
visitor_id = client.get_visitor_identifier.inspect
puts "* Visitor ID=#{visitor_id}"
puts "* Posting event"
puts client.post_event(visitor_id).inspect
