class MerchantsController < ApplicationController 
  require 'prawn'
  require 'prawn/qrcode'

  before_action :create_user_login

  def manage
    if @user.queue_enabled?
      render 'status'
    else
      render 'show'
    end
  end

  def reset_queue
    ActiveRecord::Base.transaction do
      @user.owned_queue_slots.delete_all
    end
    render 'status'
  end

  def update
    p_params = params.permit(:name, :pq_len, :queue_enabled) 
    queue_enabled = p_params.include? :queue_enabled
    @user.update({ 
      name: p_params[:name], qlength: p_params[:pq_len], 
      queue_enabled: queue_enabled
    })
    render 'status'
  end

  def reset_queue_pdf
    @user.update(
      join_code: SecureRandom.alphanumeric
    )
    redirect_to action: :queue_pdf
  end

  def queue_pdf
    
    port = 33851
    data_url = "http://192.168.43.64:#{port}/add_queue/#{@user.join_code}"
    #data_url= "https://hr.qnow.app/add_queue/#{@user.join_code}"
    qrcode = RQRCode::QRCode.new(data_url, level: :h, size: 20)
    data = data_url
    
    pdf_file = Prawn::Document::new(page_size: 'A4', margin: [0,0,0,0]) do
      move_down 220
      #text 'Sample autosized QR-Code (with and without stroked bounds) Size of QRCode : 2 in (144 pt)', extent: 300 
      cpos = cursor
      print_qr_code(data, extent: 600, stroke: false)
      move_down 10

    end

    send_data pdf_file.render,
      filename: "export.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def show
  end

  def status
  end

  def render_404
    render(json: {}.to_json, status: 404)
  end

end
