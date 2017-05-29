# frozen_string_literal: true
module ReservationsHelper

  def find_servers_for_user
    @reservation = new_reservation
    @servers = free_servers
    render :find_servers
  end

  def find_servers_for_reservation
    @reservation = reservation
    @servers = free_servers
    render :find_servers
  end

  def update_reservation
    if reservation.update_attributes(reservation_params)
      if reservation.now?
        reservation.update_reservation
        flash[:notice] = "Reservation updated for #{reservation}, your changes will be active after a mapchange."
      else
        flash[:notice] = "Reservation updated for #{reservation}"
      end
      redirect_to root_path
    else
      render :edit
    end
  end

  def find_reservation
    if params[:id].to_i > 0
      if current_admin || current_streamer
        Reservation.find(params[:id].to_i)
      else
        current_user.reservations.find(params[:id].to_i)
      end
    end
  end

  def new_reservation
    new_reservation_attributes = { :starts_at => starts_at,
                                   :ends_at   => ends_at }
    if previous_reservation
      previous_reservation_attributes = previous_reservation.reusable_attributes
      new_reservation_attributes.merge!(previous_reservation_attributes)
    end

    current_user.reservations.build(new_reservation_attributes)
  end

  def free_servers
    @free_servers ||= begin
                        if current_user.geocoded?
                          free_server_finder.servers.near(current_user, 50000, order: "distance, position, name")
                        else
                          free_server_finder.servers.order("position, name")
                        end
                      end
  end

  def free_server_finder
    if @reservation.persisted?
      if params[:reservation]
        @reservation.starts_at = reservation_params[:starts_at]
        @reservation.ends_at = reservation_params[:ends_at]
      end
      ServerForReservationFinder.new(@reservation)
    else
      ServerForUserFinder.new(current_user, @reservation.starts_at, @reservation.ends_at)
    end
  end

  def cancel_reservation
    flash[:notice] = "Reservation for #{@reservation} cancelled"
    reservation.destroy
  end

  def end_reservation
    reservation.update_attribute(:end_instantly, true)
    reservation.end_reservation
    link = "/uploads/#{reservation.zipfile_name}"
    flash[:notice] = "Reservation removed, restarting server. Your STV demos and logs will be available <a href='#{link}' target=_blank>here</a> soon".html_safe
  end

  def previous_reservation
    current_user.reservations.last
  end

  private

  def reservation_params
    permitted_params = [:id, :password, :tv_password, :tv_relaypassword, :server_config_id, :first_map, :auto_end, :enable_plugins]
    if reservation.nil? || (reservation && reservation.schedulable?)
      permitted_params += [:rcon, :server_id, :starts_at, :ends_at]
    end
    params.require(:reservation).permit(permitted_params)
  end

  def starts_at
    (params[:reservation] && params[:reservation][:starts_at].presence) || params[:starts_at].presence || Time.current
  end

  def ends_at
    (params[:reservation] && params[:reservation][:ends_at].presence) || params[:ends_at].presence || 2.hours.from_now
  end

end
