function test(...)
    print("test called with arg: " .. tostring(...))
end;

test{a=function()return 1 end}.a()