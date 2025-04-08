function SHELLSORT(arr)
    local steps = {}
    local cnt = 0
    local step = #arr // 2
    while step > 0 do
        for i = step, #arr do
            local j = i
            local delta = j - step
            for i = 0, #arr do
                print(i, arr[i])
            end                     
            while (delta >= 0 and arr[delta] > arr[j]) do
                cnt = cnt + 1
                local temp = arr[delta]
                arr[delta] = arr[j]
                arr[j] = temp
                j = delta
                delta = j - step
            end
        end
        table.insert(steps, step)
        step = step // 2
    end
    print('\nШаги:', table.concat(steps, '\n')) 
    print('\nМассив (отсортирован):', table.concat(arr, '\n'))
    print('Количество сравнений:', cnt)
end

function RANDOMTABLE(n)
    local arr = {}
    for i = 0, n do
        arr[i] = math.random(1, 1000)
    end
    return arr
end

print(SHELLSORT(RANDOMTABLE(10)))
