class Api::SitesController < Api::ApiController
  skip_before_action :verify_authenticity_token

  def post
    puts "GOTT TESXTTTTT #{params[:name]}}"


    action = {
      type: 'action',
      function: params[:function], # string
      target: params[:target],
      value: params[:value]
    }

    ActionCable.server.broadcast("sites.#{params[:name]}", action)
  end

end

=begin
curl -X POST "localhost:3000/api/sites/test1/post" \
     -H "Content-Type: application/json" \
     -d '{"function": "set", "target": "#heading", "value":"This is the new heading!"}'

curl -X POST "localhost:3000/api/sites/test1/post" \
     -H "Content-Type: application/json" \
     -d '{"function": "append", "target": "#list", "value":"<tr><td>This is the new heading!</td></tr>"}'

curl -X POST "localhost:3000/api/sites/test1/post" \
     -H "Content-Type: application/json" \
     -d '{"function": "speak", "value":"This is the new heading!"}'
=end