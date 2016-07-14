(function($)
{
	$.Redactor.prototype.imagemanager = function()
	{
		return {
			langs: {
				en: {
					'upload': 'Upload',
					'choose': 'Choose'
				}
			},
			init: function()
			{
				if (!this.opts.imageManagerJson)
				{
					return;
				}

				this.modal.addCallback('image', this.imagemanager.loadItemsOnly);
			},
			load: function()
			{
				var $modal = this.modal.getModal();

				this.modal.createTabber($modal);
				this.modal.addTab(1, this.lang.get('upload'), 'active');
				this.modal.addTab(2, this.lang.get('choose'));

				$('#redactor-modal-image-droparea').addClass('redactor-tab redactor-tab1');

				var $box = $('<div id="redactor-image-manager-box" style="overflow: auto; height: 300px;" class="redactor-tab redactor-tab2">').hide();
				$modal.append($box);

				var csrfMeta = document.querySelector('meta[name="csrf-token"]');
				var csrfToken = csrfMeta && csrfMeta.getAttribute('content');
				var authenticityToken = $('<input type="hidden" id="image_upload_auth_token" name="request_forgery_protection_token" value="' + csrfToken + '" >');
				$modal.append(authenticityToken);

				$.ajax({
					dataType: 'json',
					cache: false,
					url: this.opts.imageManagerJson,
					success: $.proxy(function(collection)
					{
						$.each(collection.items, $.proxy(function(key, val)
						{
							// title
							var thumbtitle = '';
							if (typeof val.name !== 'undefined')
							{
								thumbtitle = val.name;
							}

							var image = val.image;
							if (typeof image == 'object')
							{
								var img = $('<img src="' + image['thumbnail/small']['contentUrl'] + '" rel="' + image['thumbnail/medium']['contentUrl'] + '" item_id="' + val.id + '"title="' + thumbtitle + '" style="width: 100px; height: 75px; cursor: pointer;" />');
								$('#redactor-image-manager-box').append(img);
								$(img).click($.proxy(this.imagemanager.insert, this));
							}
						}, this));
					}, this)
				});
			},
      // Similar to the load function, except this one only allows selecting existing items.
      loadItemsOnly: function()
      {
        var $modal = this.modal.getModal();

        $('#redactor-modal-image-droparea').remove();
        var $box = $('<div id="redactor-image-manager-box" style="overflow: auto; height: 300px;" class="redactor-tab redactor-tab2">');
        $modal.append($box);

        var csrfMeta = document.querySelector('meta[name="csrf-token"]');
        var csrfToken = csrfMeta && csrfMeta.getAttribute('content');
        var authenticityToken = $('<input type="hidden" id="image_upload_auth_token" name="request_forgery_protection_token" value="' +
                                  csrfToken + '" >');
        $modal.append(authenticityToken);

        $.ajax({
          dataType: 'json',
          cache: false,
          url: this.opts.imageManagerJson,
          success: $.proxy(function(collection)
          {
            $.each(collection.items, $.proxy(function(key, val)
            {
              // title
              var thumbtitle = '';
              if (typeof val.name !== 'undefined')
              {
                thumbtitle = val.name;
              }

              var image = val.image;
              if (typeof image == 'object')
              {
                var img = $('<img src="' +
                  image['thumbnail/small'].contentUrl +
                  '" rel="' + image['thumbnail/medium'].contentUrl +
                  '" item_id="' + val.id +
                  '"title="' + thumbtitle +
                  '" style="width: 100px; height: 75px; cursor: pointer;" />');
                $('#redactor-image-manager-box').append(img);
                $(img).click($.proxy(this.imagemanager.insert, this));
              }
            }, this));
          }, this)
        });
      },
			insert: function(e)
			{
				var $el = $(e.target);

				var img = document.createElement('img');
				img.src = $el.attr('rel');
				img.alt = $el.attr('title');
				img.title = $el.attr('title');
				img.style.width = '300px';
				img.style.height = 'auto';
				img.setAttribute('class', 'hc_page_image');
				img.setAttribute('item_id', $el.attr('item_id'));
				img.setAttribute('style', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;');
				img.setAttribute('rel', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;');

				this.insert.node(img);
				this.code.sync();
				this.observe.load();
				this.modal.close();
			}
		};
	};
})(jQuery);
