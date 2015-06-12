class WeixinController < ApplicationController
  def verify
    # Weixin server verify
    echostr = params[:echostr]
    if echostr
      signature = params[:signature]
      timestamp = params[:timestamp]
      nonce = params[:nonce]
      token = 'zhangweidong'
      array = [token,timestamp,nonce].sort
      if  signature == Digest::SHA1.hexdigest(array.join)
        logger.info { "[WeixinController.verify] Verify success." }
        render :text => echostr ,:status => 200
      else
        logger.error { "[WeixinController.verify] Verify fail." }
        redirect_to routing_error
      end
    end
  end
  
  def menu1
  end
  
  def menu2
  end
  
  def menu3
  end
  
  def token
    render plain: "The token is:" + get_access_token
  end
  
  private

  def get_access_token
    if Rails.cache.read("access_token").nil?
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxd7e64f6cdd8aab71&secret=5edcd2a545056482efadbbb914b47110"
      res = RestClient.get(URI.escape(url))
      resfs = JSON.parse(res)
      Rails.cache.write("access_token", resfs['access_token'], expires_in: 5.minutes)
      return resfs['access_token']
    else
      Rails.cache.read("access_token")
    end
  end
end
