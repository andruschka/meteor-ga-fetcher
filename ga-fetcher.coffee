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
  fetchData: (opts)->
    unless @authorized is true
      @authorize()
    unless opts.ids?
      opts.ids = profileId
    opts.auth = authClient
    getDataSync = Meteor.wrapAsync analytics.data.ga.get
    data = getDataSync(opts)
    return data.rows