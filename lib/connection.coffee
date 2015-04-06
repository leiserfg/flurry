React = require 'react/addons'

ext = (obj, other)->
  for k, v of other
    if not obj.hasOwnProperty k
      obj[k] = v
  obj

module.exports =
class Connection extends React.Component
  defaultProps:
    actions: {}
  
  propTypes:
    stores: React.PropTypes.object.isRequired
    actions: React.PropTypes.object
    children: React.PropTypes.element.isRequired

  constructor:(props)->
    super props
    @state = {}
    
    for name, store of props.stores
      @state[name] = undefined

  componentDidMount: =>
    @handlers = {}
    for name, store of @props.stores
      @handlers[name] = do(name=name, update={})=>
        (value)=>
          update[name] = value
          @setState update
      store.onValue @handlers[name]

  componentWillUnmount:=>
    for name, store of @props.stores
      state.offValue @handlers[name]

    delete @handlers #thanks, bot we don't need it U any more

  render: =>
    child = React.Children.only @props.children
    dict = {'actions': @props.actions}

    if child.key 
      dict['key'] =  child.key
    
    React.addons.cloneWithProps child, ext(dict, @state)



