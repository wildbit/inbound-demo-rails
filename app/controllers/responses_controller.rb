class ResponsesController < ApplicationController

  protect_from_forgery except: :create

  def create
    # Parse the message
    message = JSON.parse(request.body.read)

    # Grab the Article ID from the message
    article_id = message['MailboxHash']

    # Find the article
    article = Article.find(article_id)

    # Create a new response
    article.responses.create(
      name: message['FromName'],
      email: message['From'],
      body: message['TextBody'] # Could also use message['HtmlBody']
    )

    # Return a 200 code so Postmark know’s the webhook was processed
    render plain: 'Response Saved', status: 200
  end
end
