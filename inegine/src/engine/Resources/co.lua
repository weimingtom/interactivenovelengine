function init()
    Trace(animatedsprite.id)
    coroutine.yield()
    return test();
end

function test()
    Trace "tail call test!"
    coroutine.yield()
    Trace "tail call test 2!"
end

init()
