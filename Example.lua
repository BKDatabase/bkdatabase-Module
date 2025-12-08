--- Example module.
-- @module example
-- @alias p
local p = {};     --Tất cả các mô đun Lua trên BKDatabase phải bắt đầu bằng cách xác định một biến
                    --biến này sẽ giữ các chức năng có thể truy cập bên ngoài của chúng.
                    --Các biến như vậy có thể có bất kỳ tên nào bạn muốn và có thể
                    --chứa nhiều dữ liệu cũng như các hàm.
--- Hello world function
-- @param {table} frame current frame
-- @return Hello world
p.hello = function( frame )     --Thêm một hàm vào "p".
                                        --Các hàm như vậy có thể được gọi trong BKDatabase
                                        --thông qua lệnh #invoke.
                                        --"frame" sẽ chứa dữ liệu mà BKDatabase
                                        --gửi chức năng này khi nó chạy.
                                 -- 'Hello' là tên do bạn lựa chọn. Tên tương tự cần được tham chiếu khi mô-đun được sử dụng.
    
    local str = "Hello World!"  --Khai báo một biến cục bộ và đặt nó bằng
                                --"Hello World!".  
    
    return str    --Điều này yêu cầu chúng tôi thoát khỏi chức năng này và gửi thông tin trong
                  --"str" trở lại BKDatabase.
    
end  -- kết thúc hàm "hello"
--- Hello world function
-- @param {table} frame current frame
-- @param {string} frame.args[1] name
-- @return Hello world
function p.hello_to(frame)		-- Thêm một hàm khác khác
	local name = frame.args[1]  -- Để truy cập các đối số được chuyển đến một mô đun, hãy sử dụng `frame.args`
							    -- `frame.args [1]` đề cập đến tham số không tên đầu tiên
							    -- được cung cấp cho mô đun
	return "Hello, " .. name .. "!"  -- `..` `..` nối các chuỗi. Thao tác này sẽ trả về một lời chào tùy chỉnh
									 -- tùy thuộc vào tên được đặt, chẳng hạn như "Hello, Fred!"
end
--- Counts fruit
-- @param {table} frame current frame
-- @param {string} frame.args.bananas number of bananas
-- @param {string} frame.args.apples number of apples
-- @return Number of apples and bananas
function p.count_fruit(frame)
	local num_bananas = frame.args.bananas -- Các đối số được đặt tên ({{#invoke:Example|count_fruit|foo=bar}}) cũng được truy cập
	local num_apples = frame.args.apples   -- bằng cách lập chỉ mục `frame.args` theo tên (`frame.args["bananas"]`, hoặc
										   -- hoặc tương đương là `frame.args.bananas`.
	return 'I have ' .. num_bananas .. ' bananas and ' .. num_apples .. ' apples'
										   -- Giống như ở trên, nối một loạt các chuỗi với nhau để tạo ra 
										   -- một câu dựa trên các đối số đã cho.
end
--- Lucky function
-- @param {string} a
-- @param {string} b
-- @return Whether a is lucky.
local function lucky(a, b) -- Người ta có thể khai báo các hàmh để sử dụng. Ở đây chúng ta khai báo một hàm 'lucky' có hai đầu vào a và b. Tên do bạn lựa chọn.
	if b == 'yeah' then -- Điều kiện: nếu b là chuỗi 'yeah'. Chuỗi yêu cầu dấu ngoặc kép. Hãy nhớ bao gồm 'then'.
		return a .. ' is my lucky number.' -- Kết quả: 'a là con số may mắn của tôi.' nếu điều kiện trên đúng. Toán tử nối chuỗi được ký hiệu bằng 2 dấu chấm.
	else -- Nếu không có điều kiện nào đúng, tức là nếu b là bất kỳ điều gì khác, đầu ra được chỉ định trên dòng tiếp theo. 'else' không nên có 'then'.
		return a -- Đơn giản chỉ cần xuất ra a
	end -- Phần 'if' phải kết thúc bằng 'end'.
end -- Giống như 'function'.
--- Name2
-- @param {table} frame current frame
-- @return Some output
function p.Name2(frame)
	-- 5 dòng tiếp theo chủ yếu để cho thuận tiện và có thể được sử dụng cho mô đun của bạn. Các điều kiện đầu ra bắt đầu trên dòng 20.
	local pf = frame:getParent().args -- Dòng này cho phép các tham số mẫu được sử dụng trong mã này một cách dễ dàng. Dấu bằng được sử dụng để khai báo các biến. 'pf' có thể được thay thế bằng một từ bạn chọn.
	local f = frame.args -- Dòng này cho phép sử dụng dễ dàng các tham số từ {{#invoke:}}. 'f' có thể được thay thế bằng một từ bạn chọn.
	local M = f[1] or pf[1] -- f[1] và pf[1] mà chúng ta vừa khai báo, sẽ tham chiếu đến tham số đầu tiên. Dòng này rút gọn chúng thành 'M' để thuận tiện. Bạn có thể sử dụng các tên biến ban đầu.
	local m = f[2] or pf[2] -- f[2] và pf[2] mà chúng ta vừa khai báo, sẽ tham chiếu đến tham số đầu tiên. Dòng này rút gọn chúng thành 'm' để thuận tiện. Bạn có thể sử dụng các tên biến ban đầu.
	local l = f.lucky or pf.lucky -- Tham số được đặt tên là 'lucky' được viết tắt là l. Lưu ý rằng cú pháp khác với các tham số không tên.
	if m == nil then -- Nếu tham số thứ hai không được sử dụng.
		return 'Lonely' -- Xuất ra chuỗi 'Lonely' nếu điều kiện đầu tiên đúng.
	elseif M > m then -- Nếu điều kiện đầu tiên không đúng, dòng này sẽ kiểm tra điều kiện thứ hai: nếu M lớn hơn m.
		return lucky(M - m, l) -- Nếu điều kiện đúng, sự khác biệt được tính toán và chuyển đến hàm tự xác định cùng với l. Đầu ra phụ thuộc vào việc l được đặt thành 'yeah' hay không.
	else
		return 'Be positive!'
	end
end

return p    --Tất cả các mô đun được kết thúc bằng cách trả về biến chứa các chức năng của chúng cho BKDatabase.
-- Chúng ta có thể sử dụng mô đun này bằng cách gọi {{#invoke: Example | hello }},
-- {{#invoke: Example | hello_to | foo }}, hoặc {{#invoke:Example|count_fruit|bananas=5|apples=6}}
-- Lưu ý rằng phần đầu tiên của lệnh gọi là tên của trang Mô đun, 
-- và phần thứ hai là tên của một trong các hàm được đính kèm với
-- biến mà bạn đã trả về.

-- Hàm "print" không được phép trong BKDatabase. Tất cả đầu ra đều được thực hiện
-- thông qua các chuỗi "return" cho BKDatabase.
