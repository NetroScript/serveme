# frozen_string_literal: true
class ServersController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    SteamCondenser::Servers::Sockets::BaseSocket.timeout = 500
    @servers = Server.active.includes([current_reservations: { :user => :groups } ], :location, :recent_server_statistics).order(:name)
  end

end
