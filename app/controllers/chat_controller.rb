class ChatController < ApplicationController
  def index
  	@messages = ChatMessage.where(:room => params[:room])
  end

  def nickname

  end

  def write
    params[:nickname].gsub!(/[^a-zA-Z0-9]/, "")
  	ChatMessage.create({
  		room: params[:room],
  		message: {
  			nickname: current_user ? current_user.firstname : "_"+params[:nickname],
  			message: params[:msg],
        admin: current_user && current_user.role.to_s != ""
  		}.to_json
  	})
    render inline: ''
  end

  def refresh
    messages = ChatMessage.where("room = ? AND id > ? AND created_at > ?", params[:room], params[:lastid], 90.minute.ago).map do |m|
      md = JSON.parse(m.message)
      {
        id: m.id,
        datetime: m.created_at.to_i,
        nickname: md["nickname"],
        message: md["message"],
        admin: md["admin"]
      }
    end
    messages.select! { |m| m[:message] && m[:message].length > 0 }
    render json: messages
  end
end
