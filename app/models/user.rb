class User < ActiveRecord::Base
  include ApplicationHelper
  devise :omniauthable

  attr_accessible :uid, :nickname, :name, :provider

  has_many :reservations
  has_many :group_users
  has_many :groups,   :through => :group_users
  has_many :servers,  :through => :groups

  def self.find_for_steam_auth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      user.update_attributes(:name => auth.info.name, :nickname => auth.info.nickname)
    else
      user = User.create(  name:      auth.info.name,
                           nickname:  auth.info.nickname,
                           provider:  auth.provider,
                           uid:       auth.uid
                         )
    end
    user
  end

  def reservation
    if just_after_midnight?
      yesterdays_reservation
    else
      todays_reservation
    end
  end

  def todays_reservation
    reservations.where(:date => Date.today).last
  end

  def yesterdays_reservation
    reservations.where(:date => Date.yesterday).last
  end

  def historic_reservations
    Version.where(:whodunnit => self.id, :item_type => Reservation).where(:event => 'create')
  end

  def has_made_many_reservations?
    historic_reservations.count >= 5
  end

end
