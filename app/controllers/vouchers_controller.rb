# frozen_string_literal: true

class VouchersController < ApplicationController
  def new
    @voucher = Voucher.find_voucher(params[:code]) if params[:code]
    @voucher ||= Voucher.new
    flash[:alert] = 'This code has already been used' if @voucher.claimed?
  end

  def create
    code = params.require(:voucher).require(:code)
    @voucher = Voucher.unclaimed.find_voucher(code)
    if @voucher
      @voucher.claim!(current_user)
      flash[:notice] = "Code activated: #{@voucher.product.name}"
      redirect_to root_path
    else
      flash[:alert] = 'Invalid code or already used'
      @voucher = Voucher.new
      render :new
    end
  end
end
