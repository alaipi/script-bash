#bash自定义echo函数，支持设置文字颜色和背景颜色
function customEcho() {
    #$1 内容
    #$2 文字颜色
    #$3 背景颜色
    fcolor="37"
    bcolor="40"
    if [ "$2" == "black" ]; then
        fcolor="30"
    elif [ "$2" == "red" ]; then
        fcolor="31"
    elif [ "$2" == "green" ]; then
        fcolor="32"
    elif [ "$2" == "yellow" ]; then
        fcolor="33"
    elif [ "$2" == "blue" ]; then
        fcolor="34"
    elif [ "$2" == "white" ]; then
        fcolor="37"
    fi
    
    if [ "$3" == "black" ]; then
        bcolor="40"
    elif [ "$3" == "red" ]; then
        bcolor="41"
    elif [ "$3" == "green" ]; then
        bcolor="42"
    elif [ "$3" == "yellow" ]; then
        bcolor="43"
    elif [ "$3" == "blue" ]; then
        bcolor="44"
    elif [ "$3" == "white" ]; then
        bcolor="47"
    fi
    
    #格式 echo -e "\033[字背景颜色;字体颜色m字符串\033[控制码"
    echo -e "\e[${fcolor};${bcolor}m $1 \e[0m"
}

customEcho "www.phpernote.com" red
