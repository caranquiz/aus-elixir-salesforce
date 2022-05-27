(function(skuid){
(function(skuid){
    
	var $ = skuid.$,
	    registerSnippet = skuid.snippet.registerSnippet;
	
	var defaultThemeImageUrl = skuid.utils.getStaticResourceUrl("DefaultPhotos","skuid","Org.jpg");
	
	// Base snippet for picklists whose entries come from rows in another model
    var modelSourcedPicklist = function(config){
        
        var field = config.field,
            value = skuid.utils.decodeHTML(config.value),
            filterFunction = config.filterFunction,
            isRequired = config.isRequired,
            model = config.model,
            data = model.getRows();
        
        if (field.mode === 'edit') {
            
            field.element.html(skuid.ui.renderers.PICKLIST.edit({
                value: value,
                required: isRequired,
                onChange: function(value){
                    field.model.updateRow(field.row,field.id,value, {initiatorId: field._GUID });
                },
                entries: $.map(filterFunction ? data.filter(filterFunction) : data,function(item){
                    return {
                        label: item.Name,
                        value: item.Name
                    };
                })
            }));
        } else {
            skuid.ui.getFieldRenderer(field.metadata.displaytype)[field.mode](field,value);
        }
    };
	    
	// Base snippet for ThemePicker picklists
    var themePicker = function(config){
        var themeType = config.type;
        $.extend(config,{
            isRequired:true,
            filterFunction: function(theme){
                return ((theme.skuid__Type__c === themeType) && theme.skuid__Active__c);
            },
            model: skuid.$M('Themes_'+themeType)
        });
        return modelSourcedPicklist(config);
    };
    
    // Render a text field as a picklist
    var textAsPicklist = function(config) {
        var field = config.field,
            value = config.value,
            entries = config.entries,
            onChange = config.onChange;
        if (field.mode === 'edit') {
            field.element.html(skuid.ui.renderers.PICKLIST.edit({
                value: value,
                required: true,
                onChange: function(value){
                    field.model.updateRow(field.row,field.id,value,{ initiatorId: field._GUID });
                    onChange && config.onChange(value);
                },
                entries: entries
            }));
        } else {
            // If we find our value in our entries, use the entry's Label as our display value
            $.each(entries,function(){
               if (value === this.value) {
                   value = this.label;
                   return false;
               } 
            });
            skuid.ui.getFieldRenderer(field.metadata.displaytype)[field.mode](field,value);
        }    
    };
    
    // polymorphic lookup
    var limitedLookup = function(field,value,targetObjects,renderAsPicklist){
        
        value = skuid.utils.decodeHTML(value);
        
        var metadata = field.metadata;
        
        if (field.mode == 'edit') {
            
            metadata = {};
            $.extend(true,metadata,field.metadata); // do a deep clone
            field.metadata = metadata;
            
            // Limit the set of target objects
            var targets = [],
                uniqueTargets = {};
            $.each(metadata.referenceTo,function(i,r){
                if (($.inArray(r.objectName,targetObjects) != -1)
                && (!uniqueTargets[r.objectName])) {
                    targets.push(r);
                    uniqueTargets[r.objectName] = 1;
                    if (targets.length == targetObjects.length) return false;
                }
            });
            if (targets.length) {
                // Make this field render as a picklist?
                if (renderAsPicklist) field.options.type = 'REFPICK';
                // Override the current referenceTo
                metadata.referenceTo.length = 0;
                var ref = [];
                $.each(targets,function(){
                	ref.push(this.objectName);
                });
                metadata.ref = ref.join();
                metadata.referenceTo = targets;
            }
            
        }
        
        // Run the standard renderer
        skuid.ui.getFieldRenderer(metadata.displaytype)[field.mode](field,value);
        // Set the field renderer BACK to custom so that our renderer will work correctly
        // the second time
        if (renderAsPicklist) field.options.type = 'CUSTOM';    
    };
    
    var _getThemeResourceUrl = function(themeResources,resourceName,resourceNamespace){
        var target,
            ns,
            modstamp;
        $.each(themeResources,function(i,r){
            // Resource Name must match exactly
            if ((r.Name === resourceName) 
            // Namespace Prefix must either match exactly, or must be falsey for both
            && (
               (r.NamespacePrefix === resourceNamespace) || (!resourceNamespace && !r.NamespacePrefix)
            )){
               target = r;
               return false;
           } 
        });
        // If we found a Theme Resource, get its Modstamp 
        // so that we get the most recent / non-cached version of its files
        modstamp = target ? skuid.time.parseSFDateTime(target.SystemModstamp).getTime() : '';
        if (target) ns = target.NamespacePrefix;
        return skuid.utils.getStaticResourceUrl(resourceName,ns,undefined,modstamp);
    };
    
    // Theme Picker Dialog
    var niceThemePicker = function(config) {
        
        var field = config.field,
            value = config.value,
            themes = config.themes,
            themeResources = config.themeResources,
            dialogTitle = config.dialogTitle || 'Choose Theme';
        
        if (field.mode==='edit') {
            
            // Show a Theme Picker dialog
            var showDialog = function(){
                var dialog = $('<div>');
                // Add a Content area for each Theme
                var themesWrapper = $('<div class="themes-wrapper">');
                $.each(themes,function(i,theme){
                    var themeDiv = $('<div data-theme="'+theme.Name+'">').addClass('theme-card');
                    if (theme.Name === value) themeDiv.addClass('selected');
                    var themeLabel = $('<div class="theme-label">').text(theme.Name);
                    var resourceNamespace = theme.skuid__Resource_Namespace__c;
                    var resourceName = theme.skuid__Resource_Name__c;
                    // Get the Theme's Resource URL, and append the screenshot file location
                    var themeScreenshotUrl = _getThemeResourceUrl(themeResources,resourceName,resourceNamespace) + "/screenshot.png";
                    var screenshot = $('<div class="theme-screenshot">').append(
                        $('<img>').attr({
                            src: themeScreenshotUrl,
                            width: '350',
                        })
                    );
                    themeDiv.append(screenshot,themeLabel);
                    themesWrapper.append(themeDiv);
                });
                themesWrapper.on('click','.theme-card',function(){
                    var themeDiv = $(this),
                        themeName = themeDiv.data('theme');
                    field.model.updateRow(field.row,field.id,themeName, {initiatorId: field._GUID });
                    dialog.dialog('close');
                });
                dialog.append(themesWrapper);
                    
                dialog.dialog({
                    width: '90%',
                    height: 600,
                    modal: true,
                    title: dialogTitle,
                    close: function(){
                        if (!isTable) field.mode = 'read';
                        field.render();
                    }
                });    
            };
            
            // if this renderer is used in a Table, 
            // then show a "Choose Theme..." link or something like that
            var isTable = field.item.list.editor.element.is('.nx-skootable');
            if (isTable) {
                // And then append "click to edit"
                field.element.append(
                    $('<div class="nx-fieldtext">').text(value).append(
                        $('<button>').css({ "cursor":"pointer","margin-left": "10px","vertical-align":"middle"}).append(
                            $('<div class="sk-icon inline sk-icon-photoview">')
                        ).skootip('Click to change Theme')
                        .on('click',showDialog)
                    )
                );
            } else {
                // Otherwise just show the picker right away
                showDialog();
            }   
        } else {    
            skuid.ui.getFieldRenderer(field.metadata.displaytype)[field.mode](field,value);
        }
        
    };
    
    registerSnippet('ThemeNameRenderer',function(){
        var field = arguments[0],
            value = skuid.utils.decodeHTML(arguments[1]);
        field.options.noLink = true;
        skuid.ui.getFieldRenderer(field.metadata.displaytype)[field.mode](field,value);
        
    });
    
    // Composer Theme Picker - Desktop
    registerSnippet('ThemePicker_Composer_Desktop',function(field,value){
        var composerThemes = ['Composer Light', 'Composer Dark'];
        niceThemePicker({
            field: field,
            value: value,
            themes: skuid.$M('stng__Themes_Desktop').getRows([
                { field: 'Name', operator: 'in', values: composerThemes, type: 'multiple' }
            ]),
            themeResources: skuid.$M('stng__DesktopThemeResources').getRows(),
            dialogTitle: 'Choose Desktop Composer Theme'
        });
    });
    
    // Composer Theme Picker - Mobile
    registerSnippet('ThemePicker_Composer_Mobile',function(field,value){
        return modelSourcedPicklist({
            field: field,
            value: value,
            isRequired: true,
            model: skuid.$M('stng__Themes_Mobile'),
            filterFunction: function(theme){
                return (
                    (theme.skuid__Type__c === 'Mobile') 
                    && ($.inArray(theme.Name,['MobileClassic'])!==-1)
                );
            }
        });
    });
    
    // Desktop ThemePicker
    registerSnippet('ThemePicker_Desktop',function(field,value){
        niceThemePicker({
            field: field,
            value: value,
            themes: skuid.$M('stng__Themes_Desktop').getRows([
                { field: 'Name', operator: 'not in', values: ['Composer Light', 'Composer Dark'], type: 'multiple' },
                { field: 'skuid__Active__c', value: true }
            ]),
            themeResources:  skuid.$M('stng__DesktopThemeResources').getRows()
        });
    });
    
    // Mobile ThemePicker
    registerSnippet('ThemePicker_Mobile',function(field,value){
        niceThemePicker({
            field: field,
            value: value,
            themes: skuid.$M('stng__Themes_Mobile').getRows([{ field: 'skuid__Active__c', value: true }]),
            themeResources: skuid.$M('stng__MobileThemeResources').getRows()
        });
    });

    // User/Profile Lookup
    registerSnippet('UserOrProfileLookup',function(field,value){
        limitedLookup(field,value,['User','Profile'],false);
    });
    
    // Preload the default Theme image
    var defaultThemeImage = new Image();
    defaultThemeImage.src = defaultThemeImageUrl;
    
	
})(skuid);;
(function(skuid){
	var $ = skuid.$;
	function checkShow(rows){
  	var filteredRows = rows.filter(function(row) { 
			return skuid.themeBuilder.utils.baseThemes.indexOf(row.skuid__Resource_Name__c) === -1; 
		});
		$('#updateAllThemesButton').hide();
		$.each(filteredRows, function(i, el){
		    if(el.skuid__Skuid_Version_Date__c != skuid.version.date && el.skuid__Skuid_Version_Date__c != '-1'){
		        $('#updateAllThemesButton').show();
		    }
		});
	}
	function getRowsInModels(modelIds) {
	    var rows = [];
	    modelIds.forEach(function(modelId){
	       var model = skuid.$M(modelId);
	       if (model) {
	           var modelRows = model.getRows();
	           if (modelRows && modelRows.length) {
	               Array.prototype.push.apply(rows, modelRows);
	           }
	       }
	    });
	    return rows;
	}
	skuid.events.subscribe('models.saved', function(data){
	    checkShow(getRowsInModels([
	        "stng__Themes_Import", 
	        "stng__Themes_Desktop", 
	        "stng__Themes_Mobile"
        ]));
	});

	$(document.body).one('pageload',function(){
		checkShow(getRowsInModels([
	        "stng__Themes_Desktop", 
	        "stng__Themes_Mobile"
        ]));
	    
	});
})(skuid);;
}(window.skuid));