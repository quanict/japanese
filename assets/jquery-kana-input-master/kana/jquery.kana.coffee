#
# jQuery-kana v0.1.0
#
# jQuery Plugin that adds hiragana and katakana functionality to an input tag.
#
# Written by Andreas Argelius (andreas@argeli.us)
# Release under the BSD license.
#

$ ->
    getCursorPosition = (element) ->
        el = $(element).get 0
        pos = 0
        if "selectionStart" of el
            pos = el.selectionStart
        else if "selection" of document
            el.focus()
            sel = document.selection.createRange()
            selLength = document.selection.createRange().text.length
            sel.moveStart "character", -el.value.length
            pos = sel.text.length - selLength
        pos

    setCursorPosition = (element, pos) ->
        el = $(element).get 0
        el.focus()

        if "selectionStart" of el
            element.selectionStart = element.selectionEnd = pos

    hiraganaToKatakana = (str) ->
        str = str.split("").map (c) ->
            code = c.charCodeAt(0)
            if code >= 0x3041 and code <= 0x3094
                # Difference between ぁ and ァ.
                String.fromCharCode(code + (0x30A1-0x3041))
            else
                c
        str.join("")

    $.fn.kana = (options) ->
        opts = $.extend {}, $.fn.kana.defaults, options

        if opts.mode not in ["hiragana", "katakana", "romaji"]
            throw "Mode must be either hiragana, katakana or romaji."

        input = ""
        lastPos = getCursorPosition(this)
       
        # Unbind event if it was already initialized.
        @unbind "input"

        @on "input", ->
            if opts.mode not in ["hiragana", "katakana"]
                return

            table = $.fn.kana.tables[opts.mode]
            currentPos = getCursorPosition(this)
            val = $(this).val()

            # Should start a new string if cursor moved.
            if currentPos != lastPos+1
                input = ""

            input += val[currentPos-1] or ""

            tmp = input
            while tmp.length
                if tmp of table
                    # Translate string to kana.
                    val = val[0...currentPos-tmp.length] + table[tmp] + val[currentPos...val.length]
                    $(this).val(val)
                    setCursorPosition(this, currentPos-tmp.length+table[tmp].length)
        
                    if table[tmp][0] in ["ん", "ン", "っ", "ッ"]
                        input = table[tmp][1]
                    else
                        input = ""
                    break
                
                tmp = tmp[1..input.length]

            lastPos = currentPos
        this

    $.fn.kana.defaults = {
        "mode": "hiragana"
    }

    $.fn.kana.tables =
        hiragana:
            a: "あ"
            i: "い"
            u: "う"
            e: "え"
            o: "お"
            ka: "か"
            ki: "き"
            ku: "く"
            ke: "け"
            ko: "こ"
            kya: "きゃ"
            kyi: "きぃ"
            kyu: "きゅ"
            kyo: "きょ"
            kye: "きぇ"
            sa: "さ"
            si: "し"
            shi: "し"
            su: "す"
            se: "せ"
            so: "そ"
            sha: "しゃ"
            sya: "しゃ"
            syi: "しぃ"
            shu: "しゅ"
            syu: "しゅ"
            sho: "しょ"
            syo: "しょ"
            she: "しぇ"
            sye: "しぇ"
            ta: "た"
            ti: "ち"
            chi: "ち"
            tu: "つ"
            tsu: "つ"
            te: "て"
            to: "と"
            cha: "ちゃ"
            tya: "ちゃ"
            tyi: "ちぃ"
            tsi: "つぃ"
            chu: "ちゅ"
            tyu: "ちゅ"
            cho: "ちょ"
            tyo: "ちょ"
            che: "ちぇ"
            tye: "ちぇ"
            na: "な"
            ni: "に"
            nu: "ぬ"
            ne: "ね"
            no: "の"
            nya: "にゃ"
            nyi: "にぃ"
            nyu: "にゅ"
            nye: "にぇ"
            nyo: "にょ"
            ha: "は"
            hi: "ひ"
            hu: "ふ"
            he: "へ"
            ho: "ほ"
            hya: "ひゃ"
            hyi: "ひぃ"
            hyu: "ひゅ"
            hye: "ひぇ"
            hyo: "ひょ"
            fa: "ふぁ"
            fi: "ふぃ"
            fu: "ふ"
            fe: "ふぇ"
            fo: "ふぉ"
            fya: "ふゃ"
            fyi: "ふぃ"
            fyu: "ふゅ"
            fye: "ふぇ"
            fyo: "ふょ"
            ma: "ま"
            mi: "み"
            mu: "む"
            me: "め"
            mo: "も"
            mya: "みゃ"
            myi: "みぃ"
            myu: "みゅ"
            mye: "みぇ"
            myo: "みょ"
            ya: "や"
            yi: "い"
            yu: "ゆ"
            ye: "いぇ"
            yo: "よ"
            ra: "ら"
            ri: "り"
            ru: "る"
            re: "れ"
            ro: "ろ"
            rya: "りゃ"
            ryi: "りぃ"
            ryu: "りゅ"
            rye: "りぇ"
            ryo: "りょ"
            la: "ら"
            li: "り"
            lu: "る"
            le: "れ"
            lo: "ろ"
            lya: "りゃ"
            lyi: "りぃ"
            lyu: "りゅ"
            lye: "りぇ"
            lyo: "りょ"
            wa: "わ"
            wi: "うぃ"
            wu: "う"
            we: "うぇ"
            wo: "を"
            wya: "うゃ"
            wyi: "ゐ"
            wyu: "うゅ"
            wye: "ゑ"
            wyo: "うょ"
            da: "だ"
            di: "ぢ"
            du: "づ"
            de: "で"
            do: "ど"
            dya: "ぢゃ"
            dyi: "ぢぃ"
            dyu: "ぢゅ"
            dye: "ぢぇ"
            dyo: "ぢょ"
            pa: "ぱ"
            pi: "ぴ"
            pu: "ぷ"
            pe: "ぺ"
            po: "ぽ"
            pya: "ぴゃ"
            pyi: "ぴぃ"
            pyu: "ぴゅ"
            pye: "ぴぇ"
            pyo: "ぴょ"
            ga: "が"
            gi: "ぎ"
            gu: "ぐ"
            ge: "げ"
            go: "ご"
            gya: "ぎゃ"
            gyi: "ぎぃ"
            gyu: "ぎゅ"
            gye: "ぎぇ"
            gyo: "ぎょ"
            ja: "じゃ"
            ji: "じ"
            ju: "じゅ"
            je: "じぇ"
            jo: "じょ"
            jya: "じゃ"
            jyi: "じぃ"
            jyu: "じゅ"
            jye: "じぇ"
            jyo: "じょ"
            za: "ざ"
            zi: "じ"
            zu: "ず"
            ze: "ぜ"
            zo: "ぞ"
            zya: "じゃ"
            zyi: "じぃ"
            zyu: "じゅ"
            zye: "じぇ"
            zyo: "じょ"
            va: "ヴぁ"
            vi: "ヴぃ"
            vu: "ヴ"
            ve: "ヴぇ"
            vo: "ヴぉ"
            vya: "ヴゃ"
            vyu: "ヴゅ"
            vye: "ヴぃぇ"
            vyo: "ヴょ"
            ba: "ば"
            bi: "び"
            bu: "ぶ"
            be: "べ"
            bo: "ぼ"
            bya: "びゃ"
            byi: "びぃ"
            byu: "びゅ"
            bye: "びぇ"
            byo: "びょ"
            xa: "ぁ"
            xi: "ぃ"
            xu: "ぅ"
            xe: "ぇ"
            xo: "ぉ"
            xya: "ゃ"
            xyi: "ぃ"
            xyu: "ゅ"
            xye: "ぇ"
            xyo: "ょ"
            rr: "っr"
            tt: "っt"
            yy: "っy"
            pp: "っp"
            ss: "っs"
            dd: "っd"
            ff: "っf"
            gg: "っg"
            hh: "っh"
            jj: "っj"
            kk: "っk"
            ll: "ll"
            zz: "っz"
            xx: "っx"
            cc: "っc"
            vv: "っv"
            bb: "っb"
            nn: "ん"
            mm: "っm"
            nq: "んq"
            nw: "んw"
            nr: "んr"
            nt: "んt"
            np: "んp"
            ns: "んs"
            nd: "んd"
            nf: "んf"
            ng: "んg"
            nh: "んh"
            nj: "んj"
            nk: "んk"
            nl: "んl"
            nz: "んz"
            nx: "んx"
            nc: "んc"
            nv: "んv"
            nb: "んb"
            nm: "んm"
            "1": "１"
            "2": "２"
            "3": "３"
            "4": "４"
            "5": "５"
            "6": "６"
            "7": "７"
            "8": "８"
            "9": "９"
            "0": "０"
            " ": "　"
            "-": "ー"
            "_": "＿"
            ".": "。"
            ",": "、"
            ":": "："
            ";": "；"
            "'": "’"
            "*": "＊"
            "<": "＜"
            ">": "＞"
            "|": "｜"
            "+": "＋"
            "!": "！"
            "\"": "”"
            "#": "＃"
            "%": "％"
            "&": "＆"
            "(": "（"
            ")": "）"
            "=": "＝"
            "?": "？"
            "@": "＠"
            "$": "＄"
            "¥": "￥"
            "{": "｛"
            "}": "｝"
            "[": "「"
            "]": "」"
            "/": "／"
            "\\": "＼"
            "n1": "ん１"
            "n2": "ん２"
            "n3": "ん３"
            "n4": "ん４"
            "n5": "ん５"
            "n6": "ん６"
            "n7": "ん７"
            "n8": "ん８"
            "n9": "ん９"
            "n0": "ん０"
            "n ": "ん　"
            "n-": "んー"
            "n_": "ん＿"
            "n.": "ん。"
            "n,": "ん、"
            "n:": "ん："
            "n;": "ん；"
            "n'": "ん’"
            "n*": "ん＊"
            "n<": "ん＜"
            "n>": "ん＞"
            "n|": "ん｜"
            "n£": "ん£"
            "n€": "ん€"
            "n¡": "ん¡"
            "n+": "ん＋"
            "n!": "ん！"
            "n\"": "ん”"
            "n#": "ん＃"
            "n%": "ん％"
            "n&": "ん＆"
            "n(": "ん（"
            "n)": "ん）"
            "n=": "ん＝"
            "n?": "ん？"
            "n@": "ん＠"
            "n$": "ん＄"
            "n¥": "ん￥"
            "n{": "ん｛"
            "n}": "ん｝"
            "n[": "ん「"
            "n]": "ん」"
            "n/": "ん／"
            "n\\": "ん＼"
            "nå": "んå"
            "nä": "んä"
            "nö": "んö"
            "nø": "んø"
            "næ": "んæ"

    # Make katakana table.
    $.fn.kana.tables["katakana"] = {}
    for k, v of $.fn.kana.tables["hiragana"]
        $.fn.kana.tables["katakana"][k] = hiraganaToKatakana(v)
