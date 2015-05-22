class GaFetcher
  analytics = googleapis.analytics('v3')
  JWT = null
  profileId = null
  authClient = null
  constructor: (gapiOpts) ->
    unless gapiOpts? and gapiOpts.profileId and gapiOpts.clientEmail and gapiOpts.keyPath and gapiOpts.scopes
      console.error "You options are not complete!!! I need your {profileId, clientEmail, keyPath, scopes}"
      return undefined
    JWT = googleapis.auth.JWT
    profileId = gapiOpts.profileId
    @authorized = false
    authClient = new JWT(gapiOpts.clientEmail, gapiOpts.keyPath, null, gapiOpts.scopes)
    authClient.authorizeSync = Meteor.wrapAsync authClient.authorize
  authorize: ()->
    authClient.authorizeSync()
    if authClient.credentials.access_token?
      @authorized = true
    else
      @authorized = false
      console.error "Error @ authorize..."
  fetchData: (query)->
    unless @authorized is true
      @authorize()
    unless query.ids?
      query.ids = profileId
    if query['start-date']? and query['end-date']? and query.metrics?
      opts.auth = authClient
      getDataSync = Meteor.wrapAsync analytics.data.ga.get
      data = getDataSync(opts)
      return data.rows
    else
      throw new Error("Check your query! You have to pass atleast {start-date, end-date, metrics}.")