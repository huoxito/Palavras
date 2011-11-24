# encoding: utf-8
class PalavrasController < ApplicationController
  # GET /palavras
  # GET /palavras.json
  def index
    @palavras = Palavra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @palavras }
    end
  end

  # GET /palavras/1
  # GET /palavras/1.json
  def show
    @palavra = Palavra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @palavra }
    end
  end

  # GET /palavras/new
  # GET /palavras/new.json
  def new
    @palavra = Palavra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @palavra }
    end
  end

  # GET /palavras/1/edit
  def edit
    @palavra = Palavra.find(params[:id])
  end

  # POST /palavras
  # POST /palavras.json
  def create
    @palavra = Palavra.new(params[:palavra])

    respond_to do |format|
      if @palavra.save
        format.html { redirect_to @palavra, notice: 'Palavra was successfully created.' }
        format.json { render json: @palavra, status: :created, location: @palavra }
      else
        format.html { render action: "new" }
        format.json { render json: @palavra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /palavras/1
  # PUT /palavras/1.json
  def update
    @palavra = Palavra.find(params[:id])

    respond_to do |format|
      if @palavra.update_attributes(params[:palavra])
        format.html { redirect_to @palavra, notice: 'Palavra was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @palavra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /palavras/1
  # DELETE /palavras/1.json
  def destroy
    @palavra = Palavra.find(params[:id])
    @palavra.destroy

    respond_to do |format|
      format.html { redirect_to palavras_url }
      format.json { head :ok }
    end
  end

  # POST /search
  def search
    agent = Mechanize.new
    agent.user_agent_alias = 'Windows IE 7'
    # word =  agent.get('http://www.donquijote.org/ext/cont/pdd_en.asp?code=qcroleav').search(".//td")[1].text.gsub!( /\r|\n|\t/, "" )
    @word = []
    yeah = false
    agent.get('http://www.donquijote.org/ext/cont/pdd_en.asp?code=qcroleav') do |page|# .search(params[:word])
      @word << page.search('table').search('tr').search('td').map{ |n| n.text.force_encoding('ISO-8859-1') }
    end
    
    before = Palavra.count
    @word[0].each do |string|
      unless string.scan(params[:word]).empty?
        Palavra.create(word: params[:word])
        yeah = true
      end
    end
    after = Palavra.count
    
    message = ""
    message << "Word was found .. " if yeah
    message << "Word not found ... " unless yeah

    if before == after
      message << "But it is already on our DB."
    else
      message << " Inserted on DB !"
    end

    redirect_to palavras_url, notice: message 
  end

  def twitter
    
    word = params[:word]
    Twitter.configure do |config|
      config.consumer_key = 'zycuaTsAHbTlJycqBtC5Q'
      config.consumer_secret = 'sV2FCH6eXYc2p2c8RLXPPbPtR5DHa3pc5gXDyed4k'
      config.oauth_token = '237408303-KQAVifg06ie0iYjGP6TaJaAnVXL3bBVKCzPo6nZ1'
      config.oauth_token_secret = 'EWW0no4vxnJxb3J9Jt8EXYUifuEZN3UQFoVKVookhI'
    end
    client = Twitter::Client.new
    client.update(word)

    redirect_to palavras_url, notice: "Posted to twitter" 
  end

  def facebook
    auth = FbGraph::Auth.new("143306939107919", "d94493c784b5f9e10f13ff0dd17c2562")
    auth.client.redirect_uri = "http://localhost:3000/palavras/face_callback"
    redirect_to auth.client.authorization_uri(
        :scope => [:email, :publish_stream, :read_stream, :offline_access]
    )
  end

  def face_callback

    auth = FbGraph::Auth.new("143306939107919", "d94493c784b5f9e10f13ff0dd17c2562")
    auth.client.redirect_uri = "http://localhost:3000/palavras/face_callback"
    auth.client.authorization_code = params[:code]
    access_token = auth.client.access_token!  # => Rack::OAuth2::AccessToken
    me = FbGraph::User.me(access_token)
    me.feed!(
       :message => 'Updating via FbGraph the word',
       #:picture => 'https://graph.facebook.com/matake/picture',
       #:link => 'http://github.com/nov/fb_graph',
       #:name => 'FbGraph',
       #:description => 'A Ruby wrapper for Facebook Graph API'
    )
    # FbGraph::User.me(access_token).fetch # => FbGraph::User

    redirect_to palavras_url, notice: "Posted to facebook"  
  end

end
