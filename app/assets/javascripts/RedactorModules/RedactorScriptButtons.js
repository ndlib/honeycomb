(function($)
{
  $.Redactor.prototype.scriptbuttons = function()
     {
         return {
             init: function()
             {
                 var sup = this.button.add('superscript', 'x²');
                 var sub = this.button.add('subscript', 'x₂');

                 this.button.addCallback(sup, this.scriptbuttons.formatSup);
                 this.button.addCallback(sub, this.scriptbuttons.formatSub);
             },
             formatSup: function()
             {
                 this.inline.format('sup');
             },
             formatSub: function()
             {
                 this.inline.format('sub');
             }
         };
     };
})(jQuery);
