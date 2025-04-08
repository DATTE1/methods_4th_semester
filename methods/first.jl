for i in 1:100
  if i % 15 == 0    
    i = "FizzBuzz!"
  elseif i % 5 == 0    
    i = "Buzz!"
  elseif i % 3 == 0
    i = "Fizz!"
  end
  println(i)
end
