<section id="widget-grid" class="">
    <div class="row">
        <article class="col-sm-12 col-md-12 col-lg-12">
            <div class="jarviswidget" id="wid-id-0" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false">
                <header>
                    <span class="widget-icon"> <i class="fa fa-edit"></i></span>
                    <h2>Form Grid </h2>
                </header>
                <div>
                    <div class="jarviswidget-editbox"></div>
                    <div class="widget-body {*no-padding*}">
                        <form action="" method="post" class="smart-form" >
                            <fieldset>
                                {if isset($fields) && $fields|@count > 0}
                                    {foreach $fields AS $name=>$field }
                                        {inputs name=$name}
                                    {/foreach}
                                {/if}
                            </fieldset>
                            <footer class="smart-form" >
                                <button class="btn btn-primary" type="submit"> Submit Form </button>
                            </footer>
                        </form>
                    </div>
                </div>
            </div>
        </article>
    </div>
</section>