# Init the target input to a tag
# @jQuery(the-target)
turnToTags = (obj) ->
    tagWrapper = document.createElement 'div'
    tagWrapper.className = 'tags-wrapper'

    tagInput = document.createElement 'input'
    tagInput.className = 'tags-input'

    $(tagWrapper).html tagInput
    obj.after tagWrapper
    obj.css 'display', 'none'

    $(tagWrapper)

# Create a tag element
# @text the text
newTag = (text) ->
    tag = document.createElement 'span'
    tag.className = 'tag'
    tag.innerHTML = text

    tag

# start flash when a tag is noticed
# @tag jQuery object
flashStart = (tag) ->
    tag.addClass 'notice'
    setTimeout () ->
        tag.removeClass 'notice'
    , 300

# notice when a tag is in the list
# @wrapper jQuery Object
# @text tag name
notice = (wrapper, text) ->
    tagList = wrapper.find 'span.tag'
    for tag in tagList
        if $(tag).html() == text
            flashStart $(tag)
            return

# Create a tag and add it to list
# @jQuery(the-user-input)
createNewTag = (obj) ->
    if obj.val().length
        tag = utils.escape obj.val()
        if tag in $('#'+obj.parent().data('origin')).val().split(',')
            notice obj.parent(), tag
            return
        # add tag before the user-input
        obj.before newTag tag
        # add text to origin input
        old = $('#'+obj.parent().data('origin')).val()
        if old.length
            old += ','
        old += tag
        $('#'+obj.parent().data('origin')).val old
        # remove text in user-input
        obj.val('')

# Delete the last tag
# @jQuery(the-user-input)
deleteLast = (obj) ->
    tagList = obj.parent().find('.tag')
    if tagList.length == 0
        return
    # remove the last tag
    toBeDel = $(tagList[tagList.length-1])
    toBeDel.detach()
    # remove from origin input
    old = $('#'+obj.parent().data('origin')).val()
    oldlist = old.split(',')
    oldlist.splice(-1, 1)
    old = oldlist.join(',')
    $('#'+obj.parent().data('origin')).val(old)

deleteTag = (obj) ->
    tag = obj.text()
    old = $('#'+obj.parent().data('origin')).val()
    oldlist = old.split(',')
    console.debug oldlist
    for i in [0...oldlist.length]
        console.debug(tag)
        console.debug(oldlist[i])
        if oldlist[i] == tag
            oldlist.splice(i, 1)
            console.debug(oldlist)
    old = oldlist.join(',')
    $('#'+obj.parent().data('origin')).val(old)
    obj.detach()

# Event Handler for key
tagKeyDown = (e) ->
    key = e.KeyCode || e.which
    if key in [188, 32, 13, 9] # ',' ' ' '<enter>' '\t'
        e.preventDefault()
        createNewTag $(e.target)
    if key == 8 and $(e.target).val().length == 0
        e.preventDefault()
        deleteLast $(e.target)

# No Need for comment
bindEvents = (obj) ->
    tagInput = obj.find '.tags-input'
    tagInput.on 'keydown', tagKeyDown
    obj.on 'click', (e) ->
        if $(e.target).hasClass 'tag'
            deleteTag $(e.target)
        tagInput.focus()

$.prototype.tags = (tagOpt) ->
    wrapper = turnToTags this
    wrapper.data('origin', this.attr('id'))
    bindEvents wrapper
