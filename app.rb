require 'pony'
require 'sinatra'
require 'twilio-ruby'

GREETING = ENV['PHONETAG_GREETING'] || 'Please leave a message after the beep'
EMAIL = ENV['PHONETAG_EMAIL']
TWILIO_SID = ENV['PHONETAG_TWILIO_SID']
TWILIO_TOKEN = ENV['PHONETAG_TWILIO_TOKEN']

twilio_client = Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN

get '/' do
  'Welcome to phone tag'
end

post '/call' do
  Twilio::TwiML::Response.new do |r|
    r.Say GREETING
    r.Record(
      :maxlength => '60',
      :action => '/recording',
      :transcribeCallback => '/transcription',
    )
  end.text
end

post '/recording' do
  logger.info "Got a new recording, listen at #{params['RecordingUrl']}.mp3"
  status 201
end

post '/transcription' do
  recording = twilio_client.recordings.get(params['RecordingSid'])
  full_text = recording.transcriptions.list().reduce('') do |text, transcription|
    text += transcription.transcription_text || ''
  end
  email_body = erb(:email, :locals => {
    :text => full_text,
    :from => params[:From],
    :recording => recording
  })
  Pony.mail(:to => EMAIL,
            :from => "no-reply@#{ENV['MAILGUN_DOMAIN'] || request.host}",
            :subject => "New Phone Call from #{params[:From]}",
            :body => email_body,
            :via => :smtp,
            :via_options => {
              :address        => ENV['MAILGUN_SMTP_SERVER'] || 'localhost',
              :port           => ENV['MAILGUN_SMTP_PORT'] || '25',
              :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
              :password       => ENV['MAILGUN_SMTP_PASSWORD'],
              :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
            })
  status 201
end
