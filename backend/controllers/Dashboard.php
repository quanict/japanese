<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Dashboard extends Admin_Controller
{
    function __construct()
    {
        parent::__construct();
    }

    function index(){
        redirect('article');
    }
}