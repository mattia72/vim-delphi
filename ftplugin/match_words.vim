
"original
    let b:match_words = '\<\%(begin\|case\|record\|object\|class\|try\)\>'
    let b:match_words .= ':\<^\s*\%(except\|finally\)\>:\<end\>'
    let b:match_words .= ',\<repeat\>:\<until\>'
    let b:match_words .= ',\<if\>:\<else\>'  
