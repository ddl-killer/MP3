;点歌系统：
;输入不同的数字，播放相应的音乐。
;其中“1”代表《刚好遇见你》音乐,“2”代表《成都》音乐,“3”代表《暧昧》音乐。
;输入数字“0”，则退出点歌系统。
;----------------------------------------------------
stack   segment para stack 'stack'
        db 100 dup ('?')
stack   ends
;----------------------------------------------------
data	segment para 'data'
tip0	db	'-----------------------------------','$'
tip1	db	'|  1: just met you-- Fei Yuqing   |','$' 
tip2	db	'|  2:    ChenDu   --  Zhao Lei    |','$' 
tip3	db	'|  3:   ambiguity -- Xue Zhiqian  |','$'
tip4	db	'|  0: exit                        |','$'
tip5	db	'  --please input your choice:      ','$'
tip		dw	tip0,tip1,tip2,tip3,tip4,tip0,tip5 ;界面
tip6	db	'music over!','$'
tip7	db	'begin:','$'
tip8	db	'end  :','$'
tip9	db	'You have exited successfully.','$'
tip10	db	'input error!please input again:','$'
time	db 'yy/mm/dd hh:mm:ss','$'				;输出时间的格式
table	db 9,8,7,4,2,0							;CMOS ROM中时间信息的存放单元

;----------------------------------------------------
;《刚好遇见你》
mus_freq1 dw 262,262,262
		  dw 262,220,524,440,440,440,392
		  dw 392,330,330,262,294,262,262
		  dw 262,220,524,587,524,524,440
		  dw 440,392,330,392,294,262,247
		  dw 262,220,524,440,440,440,392
		  dw 392,392,330,392,294,262,294
		  dw 262,247,262,262,262,294
		  dw 330,294,262,262,247,262,262
		  dw -1
mus_time1 dw 25,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,12,12,100,25,25
		  dw 25,12,12,25,12,12,100
;---------------------------------------------------
;《成都》
mus_freq2 dw 196,262
		  dw 262,294,330
		  dw 392,330,330
		  dw 330,196
		  dw 262
		  dw 294,262,220
		  dw 196,196
		  dw 262,262,294,330
		  dw 440,330,392
		  dw 330,294
		  dw 262
		  dw 294,392
		  dw 330,294
		  dw 330,392
		  dw 392,330,392
		  dw 440,524,440
		  dw 330,294,262
		  dw 294,330,330
		  dw 196,392
		  dw 330,330
		  dw 294,262,262
		  dw 196,294,262
		  dw 330,294,262
		  dw 262
		  dw -1
mus_time2 dw 25,75
		  dw 50,12,12
		  dw 25,25,25
		  dw 25,50
		  dw 75
		  dw 25,25,25
		  dw 125,25
		  dw 75,50,12,12
		  dw 25,25,50
		  dw 25,25
		  dw 75
		  dw 50,25
		  dw 25,100
		  dw 25,75
		  dw 25,25,25
		  dw 25,25,75
		  dw 25,50,25
		  dw 50,25,125
		  dw 25,100
		  dw 25,25
		  dw 25,25,75
		  dw 25,50,25
		  dw 50,12,12
		  dw 200
;-------------------------------------------------
;《暧昧》
mus_freq3 dw 262,262,262,294,262
		  dw 392,440,330,330,294
		  dw 247,247,247,262,247
		  dw 330,392,247,294,262
		  dw 220,247,220,247,220
		  dw 330,349,262,220,247
		  dw 196,262,294,294
		  dw 349,330,330,294,262,294
		  dw 330,262,262,262,294,262
		  dw 392,440,330,330,294
		  dw 294,247,247,247,262,247
		  dw 330,392,247,294,262
		  dw 220,247,220,247,220
		  dw 330,349,220,262,247
		  dw 247,330,392,294,262
		  dw -1
mus_time3 dw 25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,75
		  dw 25,50,50,25
		  dw 50,25,25,25,50,25
		  dw 75,25,25,25,25,25
		  dw 25,100,25,25,25
		  dw 75,25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,25
		  dw 100,50,25,50,75
;---------------------------------------------------
;直接定址表
mus_time  dw mus_time1,mus_time2,mus_time3
mus_freq  dw mus_freq1,mus_freq2,mus_freq3
data ends
;----------------------------------------------------
code    segment para 'code'
        assume cs:code,ss:stack,ds:data
music   proc far
			
        mov ax,data
        mov ds,ax
        
        call tips;打印界面
               
		mov bh,00;第0页
        mov dh,06;第7行
        mov dl,42;第42列
        mov ah,02
        int 10h;设置光标位置
        
		mov ah,01
		int 21h;键盘输入并回显
		
input:	cmp al,30h;和'0'比较
		jb	end_error;调用end_error处理错误输入
		cmp al,33h;和'3'比较
		ja	end_error;调用end_error处理错误输入
		cmp al,30h;判断输入是否为'0'
		je	end_exit;调用end_exit退出程序
		
		sub al,30h;ASCII码转换为对应数字
		dec al;减一，因为地址从0开始
		mov ah,0;ax寄存器高位置0
		shl ax,1;每个地址数据占两个字节，向左移位实现*2
		mov di,ax;相对位移赋值给变地寄存器实现寄存器相对寻址
		mov si,mus_freq[di]
		mov bp,mus_time[di]
		
		
		mov ah,02
		mov dh,08
		mov dl,20
		int 10h;设置光标位置
		
		mov ah,09
		lea dx,tip7
		int 21h;显示输出
		
		push dx
		mov dh,08
		mov dl,26
		call timer;调用timer子程序显示开始播放时间，dh设置显示行数，dl设置显示列数
		pop dx
		
freq:
        mov     di,[si]
        cmp     di,-1
        je      end_mus;遇到-1时中止乐曲
        mov     bx,ds:[bp]
        call    soundf;调用发声子程序
        add     si,2
        add     bp,2
        jmp     freq
end_mus:
		mov bh,00
		mov dh,10
		mov dl,26
		mov ah,2
		int 10h;设置光标位置
		
		mov	ah,09
		lea dx,tip6
		int 21h;显示输出

		mov ah,02
		mov dh,11
		mov dl,20
		int 10h;设置光标位置
		
		mov ah,09
		lea dx,tip8
		int 21h;显示输出

		push dx
		mov dh,11
		mov dl,26
		call timer;调用timer程序显示结束时间
		pop dx
		
		jmp music_end;

end_exit:
		mov bh,00
		mov dh,09
		mov dl,20
		mov ah,02
		int 10h;设置光标位置
		
		mov ah,09
		lea dx,tip9
		int 21h;显示输出
		
		jmp music_end
		
end_error:
		mov ax,0b800h
		mov es,ax
		mov si,7*160+44*2
		mov byte ptr es:[si],20h;将输入处清空，以处理第二次仍然是错误的情况

		mov bh,00
		mov dh,07
		mov dl,12
		mov ah,02
		int 10h;设置光标位置
		
		mov ah,09
		lea dx,tip10
		int 21h;显示输出
		
		mov bh,00;第0页
        mov dh,07;第7行
        mov dl,44;第44列
        mov ah,02
        int 10h;设置光标位置
        
		mov ah,01
		int 21h;键盘输入并回显
		
		jmp input
		
music_end:
        mov     ax,4c00h
        int     21h
music   endp
;-----------------------------------------------------
;发声程序
soundf	proc far
        push ax
        push bx
        push cx
        push dx
        push di
        
        mov al,0b6h
        out 43h,al;对定时器2进行初始化
        mov dx,12h
        mov ax,348Ch;12348CH/DI中存放的给定频率得到声音计数值
        div di
        out 42h,al
        mov al,ah
        out 42h,al;分两次先后装入低8位和高8位的声音计数值
        in al,61h
        mov ah,al
        or al,3
        out 61h,al;将61h端口的数据0、1位置1，发声
        
WAIT1:  mov cx,4971;4971*15.08=0.07s
        call waitf;调用延迟程序
        dec bx
        jnz WAIT1

        mov al,ah
        out 61h,al;恢复接口的值
        
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret
soundf endp
;----------------------------------------------------
;时间延迟
waitf	proc far
		push ax
waitf1:
		in	al,61h
		and	al,10h
		cmp	al,ah
		je	waitf1
		
		mov	ah,al
		loop waitf1
		
		pop	ax
		ret
waitf	endp
;------------------------------------------------------
;打印界面 按预先设定的tip中的内容输出并更改背景颜色
tips	proc far
		push ax
		push ds
		push si
		push cx
	
		mov si,offset tip
		sub si,2
		mov cx,7
		mov al,-1
tipsf:

		mov bh,0
		inc al
		mov dh,al
		mov dl,12
		mov ah,2
		int 10h
		
		push ax
		add si,2
		mov dx,[si]
		mov ah,09
		int 21h
		pop ax


		loop tipsf
		
		mov ax,0b800h
		mov es,ax
		mov bp,0
		mov si,25
colorf:;改背景颜色
		mov byte ptr es:[bp+si],00110000B;颜色属性
		add si,2
		cmp si,95;控制改色区域的列的范围
		jb colorf
		add bp,160
		mov si,25
		cmp bp,160*6;控制改色区域为1-6行
		jb colorf
		
		pop cx
		pop si
		pop ds
		pop ax
		ret
		
tips	endp
;------------------------------------------------------
;显示当前时间，dh设置输出所在的行数，dl设置列数
timer proc far
		push ax
		push ds
		push si
		push di
		push cx
		push bx
	
		mov ax,data
		mov ds,ax
start:	mov si,offset table
		mov di,offset time
		
		mov cx,6
s1:		push cx
		mov al,ds:[si]
		out 70h,al;向70h写入要访问的单元的地址
		in al,71h;从71h中得到指定单元的数据
		
		mov ah,al
		mov cl,4
		shr	ah,cl;十位数码值
		add ah,30h;转换位ASCII码
		and al,00001111b;个位数码值
		add al,30h;转换位ASCII码
		mov ds:[di],ah
		mov ds:[di+1],al
		add di,3
		inc si
		pop cx		
		loop s1
		
		mov bh,0
		mov ah,2
		int 10h;根据预先指定的dh，dl设定光标位置
		
		mov dx,offset time
		mov ah,9
		int 21h;显示输出
		
		pop bx
		pop cx
		pop di
		pop si
		pop ds
		pop ax
		ret
timer endp
;------------------------------------------------------
code    ends
;---------------------------------------------------------
        end     music                   



