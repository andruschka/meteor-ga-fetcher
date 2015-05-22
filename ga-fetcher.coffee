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
    if query?
      try
        check query,
          'ids': Match.Optional(String)
          'start-date': Match.Optional(String)
          'end-date': String
          'metrics': String
          'dimensions': Match.Optional(String)
          'filters': Match.Optional(String)
        unless query.auth?
          query.auth = authClient
        unless query.ids?
          query.ids = profileId
        getDataSync = Meteor.wrapAsync analytics.data.ga.get
        data = getDataSync(query)
        return data.rows
      catch err
        throw err
    else
      throw new Error("You have to pass at least {start-date, end-date, metrics}.")