<?php

class SyllabaryFrontend extends JP_Controller
{
    function __construct()
    {

        parent::__construct();
//         add_asset('jquery.dmak.js','dmak');
//         add_asset('jquery.dmak.js','dmak');

        //add_asset('raphael-2.2.1.min.js','raphael');
        add_asset('https://cdnjs.cloudflare.com/ajax/libs/raphael/2.2.1/raphael.js');
        add_git_assets('dmak.js','dmak');
        add_git_assets('dmakLoader.js','dmak');


    }
    function index(){
        die('show index');
    }
    /*
     * https://www.nhk.or.jp/lesson/vietnamese/syllabary/index.html#tab
     * http://www.studyjapanese.net/p/kinh-nghiem.html
     * http://akira.edu.vn/bang-chu-cai-hiragana/
     */
    function hiragana($char=NULL)
    {
        if( $char ){
            return $this->draw_char($char,"hiragana");
        }
        $data = [
            'tips'=> Modules::run("Tip/items",['chu-cai-nhat,hiragana-text'])
        ];
        temp_view('Syllabary/hiragana',$data);
    }

    function katakana($char=NULL)
    {
        if( $char ){
            return $this->draw_char($char,"katakana");
        }
        
        $data = array('tips'=>Modules::run("Tip/items",'chu-cai-nhat,katakana-text'));
        $data = array();
        temp_view('katakana',$data);

    }

    private function draw_char($romaji,$group="hiragana"){
        switch ($romaji){
            case 'aa':
                $romaji = 'a';break;
            case 'ii':
                $romaji = 'i';break;
            case 'uu':
                $romaji = 'u';break;
        
            case 'ee':
                $romaji = 'e';break;
            case 'oo':
                $romaji = 'o';break;
        }
        
        $data['group'] = $group;
        $data['romaji'] = $romaji;
        $data['tips'] = $this->tip->items("$group-text");
        temp_view('draw_json',$data);
    }
    
    function draw($char = NULL){
        $hiragana = $this->config->item('hiragana');
        $katakana = $this->config->item('katakana');

        $data = array('symbol'=>NULL,'group'=>"kanji",'read'=>$char);
        switch ($char){
            case 'aa':
                $char = 'a';break;
            case 'ii':
                $char = 'i';break;
            case 'uu':
                $char = 'u';break;

            case 'ee':
                $char = 'e';break;
            case 'oo':
                $char = 'o';break;
        }

        if( array_key_exists($char, $hiragana) ){
            $data['symbol'] = $hiragana[$char];
            $data['group'] = 'hiragana';
            $keys = array_keys($hiragana);
            $keyIndexes = array_flip($keys);

            if (isset($keys[$keyIndexes[$char]+1]))
                $data['next'] = $keys[$keyIndexes[$char]+1];
            else {
                $data['next'] = $keys[0];
            }

            if (isset($keys[$keyIndexes[$char]-1]))
                $data['pre'] = $keys[$keyIndexes[$char]-1];
            else {
                $data['pre'] = $keys[count($keys)-1];
            }

            $data['tips'] = $this->tip->items('hiragana-text');

        } elseif( array_key_exists($char, $katakana) ){
            $data['symbol'] = $katakana[$char];
            $data['group'] = 'katakana';
            $data['next'] = next($katakana);
        }
//dd($data);
        temp_view('draw',$data);
    }
}