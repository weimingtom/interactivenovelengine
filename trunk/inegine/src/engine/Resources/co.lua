function init()
    return test();
end

function test()
    Trace "tail call test!"
    startAnimation(animatedsprite);
    return test();
end

init()
