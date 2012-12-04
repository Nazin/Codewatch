// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//

var cw = null;

var Codewatch = function() {
	
	function defaultLinkBehaviour() {
		$('a[href=\'#\']').click(function(e) {
			e.preventDefault();
		});
	}
	
	function tabs() {
		
		if ($('#tabs').length) {
		
			$('#main').addClass('wide');
			$('#tabs > div:not(:eq(0))').hide();

			$('#tabs > ul li a').click(function(e) {

				e.preventDefault();

				$('#tabs > ul li.active').removeClass('active');
				$(this).parent().addClass('active');

				$('#tabs > div').hide();
				$('#tabs ' + $(this).attr('href')).show();
			});
		}
	}
	
	function taskHistoryDescription() {
		
		if ($('a.show_description').length)
			$('a.show_description').click(function(e) {
				e.preventDefault();

				var el = $($(this).attr('href'));

				if (el.is(':hidden')) {
					el.show(500);
					$(this).html('Hide description');
				} else {
					el.hide(500);
					$(this).html('Show description');
				}
			});
	}
	
	function deployment() {
		
		if ($('#projectsList .deployment').length) {
			
			$('#projectsList .deployment .failInfo a').click(function (e) {
				e.preventDefault();
				$(this).next().toggle(100);
			});
		
			var el = $('#projectsList.deployments div.deployment:first-child[data-finished=false]:not(.failedDeployment)');

			if (el.length) {

				var id = el.attr('data-id');

				var interval = setInterval(function() {
					$.get($('#deployStatus').attr('href').replace('_ID_', id), function(data) {

						var percentage = Math.round(data.filesProceeded/(data.filesTotal*1.0)*100);

						el.find('.progress > div').width(percentage + '%');

						if (percentage == 100 || data.finished)
							clearInterval(interval);

						if (data.state != 1)
							location.href = location.href;
					})
				}, 5000);
			}
		}
	}
	
	function insertLines(element) {
		
		if ($(element).length) {
		
			var line = 1;
			var lines = "";

			$(element + ' pre > div > div').each(function(i, e) {

				if (!$(e).hasClass('diff-removed')) {
					lines += line + "\n";
					line++;
				} else
					lines += "--\n";
			});

			$(element + ' td.lineNumbers').html('<pre>' + lines + '</pre>')
		}
	}
	
	var CodeReview = function() {
		
		function makeSelectable() {
			
			$('table#highlitedCode div.highlight pre').selectable({
				filter: 'div.line',
				stop: function (event, ui) {

					var prev = -1, startLine = -1, lines = 0, code = '';

					$('.ui-selected', this).each(function(i, e) {

						code += $(e).html() + "\n";

						var index = $('table#highlitedCode div.highlight pre div.line').index(this);

						if (prev != -1 && prev + 1 != index) {
							$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
							return;
						}

						lines++;
						prev = index;
						if (startLine == -1)
							startLine = index + 1;
					});

					if ($('table#highlitedCode div.highlight pre div.line.ui-selected').length) {

						$('#comment_startLine').val(startLine);
						$('#comment_lines').val(lines);
						$('#comment_code').val($.trim(code));
						$('#newComment').dialog('open');
						$('#new_comment .errors').empty();
					}
				}
			});
		}
		
		function codeSelection(id) {
			
			var startLine = parseInt($('#comments .comment[data-id=' + id + ']').data('start-line'))-1;
			var lines = parseInt($('#comments .comment[data-id=' + id + ']').data('lines')-1);
				
			$('pre.ui-selectable div.line:gt(' + startLine + '):lt(' + lines + '), pre.ui-selectable div.line:eq(' + startLine + ')').addClass('hover');
		}
		
		function codeDeselection() {
			$('pre.ui-selectable div.line.hover').removeClass('hover');
		}
		
		function initEdit() {
			
			$('#editCommentButton').click(function(e) {
				e.preventDefault();

				var id = $('#commentDetails').data('id');

				if ($('#editComment form').data('origUrl') == undefined)
					$('#editComment form').data('origUrl', $('#editComment form').attr('action'));

				$('#editComment form').attr('action', $('#editComment form').data('origUrl').replace('_ID_', id));

				$('#editComment form #edit_form_comment_comment').val($('.comment[data-id=' + id + ']').html());
				$('#editComment form #edit_form_comment_task_id').val($('.comment[data-id=' + id + ']').data('task'));

				$('#editComment').dialog('open');
			});

			$('#edit_form_new_comment').bind('ajax:beforeSend',function (evt, xhr, settings) {

				var $submitButton = $(this).find('input[name=commit]');

				if ($submitButton.val() == 'Submitting...')
					return;

				$submitButton.data('origText', $submitButton.val());
				$submitButton.val('Submitting...');
				$('#edit_form_new_comment .errors').empty();
			}).bind('ajax:complete',function (evt, xhr, status) {

				var $submitButton = $(this).find('input[name=commit]');
				$submitButton.val($submitButton.data('origText'));
			}).bind('ajax:success',function (evt, data, status, xhr) {

				$('#edit_form_new_comment .errors').empty();

				var comment = $.parseJSON(xhr.responseText);

				$('.comment[data-id=' + comment.id + ']').html(comment.comment);
				$('.comment[data-id=' + comment.id + ']').data('task', comment.task_id == null ? '' : comment.task_id);

				$('#commentDetails > .comment').html(comment.comment);

				$('#editComment').dialog('close');
			}).bind('ajax:error', function (evt, xhr, status, error) {

				var errors, errorText;

				try {
					errors = $.parseJSON(xhr.responseText);
				} catch (err) {
					errors = {message:'Please reload the page and try again'};
				}

				errorText = 'There were errors with the submission: <ul>';

				for (error in errors)
					errorText += '<li>' + error + ': ' + errors[error] + '</li>';

				errorText += '</ul>';

				$('#edit_form_new_comment .errors').html(errorText);
			});
		}
		
		function commentsResize(container) {
			
			$(container + ' .comment').unbind('click');

			var lines = new Array();

			$(container + ' .comment').each(function () {

				for (var i = $(this).data('start-line'); i < $(this).data('start-line') + $(this).data('lines'); i++) {

					if (lines[i] == undefined)
						lines[i] = 0;

					lines[i]++;
				}
			});

			var lineWidth = $('#comments').width(),
				lineHeight = $('table#highlitedCode div.highlight pre div.line').outerHeight(),
				offsetLeft = 0, prevWidth = 0, elementOuterWidth = 12, totalLines = $('table#highlitedCode div.highlight pre div.line').length;

			$(container + ' .comment').each(function () {

				var max = 1, startLine = $(this).data('start-line'), elines = $(this).data('lines');

				if (totalLines > startLine) {

					for (var i = startLine; i < startLine + elines; i++) {

						if (lines[i] != undefined && lines[i] > max)
							max = lines[i];
					}

					var newWidth = lineWidth / max - elementOuterWidth;

					if (newWidth != 0 && offsetLeft + prevWidth + newWidth < lineWidth)
						offsetLeft += prevWidth;
					else
						offsetLeft = 0;

					$(this).css({
						width: newWidth,
						top: 5 + lineHeight * (startLine - 1),
						height: elines * lineHeight - elementOuterWidth,
						left: offsetLeft
					});

					prevWidth = newWidth + elementOuterWidth;
				} else
					$(this).hide();
			});
		}
		
		function commentClick(container, selectCode) {
			
			$(container + ' .comment').click(function () {

				var id = $(this).data('id');

				$('#commentDetails').data('id', id);
				
				$('#showCommentedCode').html('Show code')
				
				if (selectCode)
					$('#showCommentedCode').hide();
				else
					$('#showCommentedCode').show();
				
				if ($('#deleteComment').length) {

					if ($('#deleteComment').data('origUrl') == undefined)
						$('#deleteComment').data('origUrl', $('#deleteComment').attr('href'));

					$('#deleteComment').attr('href', $('#deleteComment').data('origUrl').replace('_ID_', id));
				}

				if ($('#new_comment_comment').data('origUrl') == undefined)
					$('#new_comment_comment').data('origUrl', $('#new_comment_comment').attr('action'));

				$('#new_comment_comment').attr('action', $('#new_comment_comment').data('origUrl').replace('_ID_', id));

				$('#commentDetails .comments').html('');

				$.get($('#commentDetails').data('comments').replace('_ID_', id), function (data) {

					html = '';

					for (var i = 0; i < data.length; i++)
						html += '<div class="comment"><a href="/users/' + data[i].author.id + '"><b>' + data[i].author.name + '</b></a>: ' + data[i].commentText + '</div>';

					$('#commentDetails .comments').html(html);
				});

				$('#commentDetails > .comment').html($(this).html());
				$('#commentDetails .info').html('posted by <a href="' + $(this).data('author-url') + '">' + $(this).data('author') + '</a> on ' + $(this).data('posted'));
				$('#commentDetails').show();
				
				if (selectCode)
					setTimeout(function() {codeSelection(id);}, 50);

				location.hash = '#comment_' + id;
			});
		}
		
		function initComments(all) {

			commentsResize('#comments');
			commentClick('#comments', true);
			
			if (all) {
				commentsResize('#old_comments');
				commentClick('#old_comments', false);
			}

			$('#comments .comment').unbind('mouseenter').unbind('mouseleave');

			$('#comments .comment').mouseenter(function() {
				codeSelection($(this).data('id'));
			}).mouseleave(function() {
				codeDeselection();
			});
		}
		
		function initAddition() {
			
			$('#new_comment').bind('ajax:beforeSend',function (evt, xhr, settings) {

				var $submitButton = $(this).find('input[name=commit]');

				if ($submitButton.val() == 'Submitting...')
					return;

				$submitButton.data('origText', $submitButton.val());
				$submitButton.val('Submitting...');
				$('#new_comment .errors').empty();
			}).bind('ajax:complete',function (evt, xhr, status) {

				var $submitButton = $(this).find('input[name=commit]');
				$submitButton.val($submitButton.data('origText'));
			}).bind('ajax:success',function (evt, data, status, xhr) {

				$('#new_comment .errors').empty();
				$('#comment_comment').val('');
				$('#newComment').dialog('close');

				var comment = $.parseJSON(xhr.responseText);
				var html = '<div class="comment" data-id="' + comment.id + '" data-start-line="' + comment.startLine + '" data-task="' + (comment.task_id == null ? '' : comment.task_id) + '" data-posted="' + comment.created_at + '" data-lines="' + comment.lines + '" data-author="' + comment.author.name + '" data-author-url="/users/' + comment.author.id + '">' + comment.comment + '</div>';

				var prev = null, broken = false;

				$('#comments .comment').each(function () {

					if ($(this).data('start-line') >= comment.startLine) {
						broken = true;
						return;
					}

					prev = $(this);
				});

				if (broken && prev != null)
					$(prev).after(html);
				else if (broken && prev == null)
					$('#comments > div').prepend(html);
				else
					$('#comments > div').append(html);

				initComments(false);
			}).bind('ajax:error', function (evt, xhr, status, error) {

				var errors, errorText;

				try {
					errors = $.parseJSON(xhr.responseText);
				} catch (err) {
					errors = {message:'Please reload the page and try again'};
				}

				errorText = 'There were errors with the submission: <ul>';

				for (error in errors)
					errorText += '<li>' + error + ': ' + errors[error] + '</li>';

				errorText += '</ul>';

				$('#new_comment .errors').html(errorText);
			});
		}
		
		function initCommenting() {
			
			$('#new_comment_comment').bind('ajax:beforeSend',function (evt, xhr, settings) {

				var $submitButton = $(this).find('input[name=commit]');

				if ($submitButton.val() == 'Submitting...')
					return;

				$submitButton.data('origText', $submitButton.val());
				$submitButton.val('Submitting...');
				$('#new_comment_comment .errors').empty();
			}).bind('ajax:complete',function (evt, xhr, status) {

				var $submitButton = $(this).find('input[name=commit]');
				$submitButton.val($submitButton.data('origText'));
			}).bind('ajax:success',function (evt, data, status, xhr) {

				$('#new_comment_comment .errors').empty();
				$('#comment_comment_commentText').val('');

				var comment = $.parseJSON(xhr.responseText);
				var html = '<div class="comment"><a href="/users/' + comment.author.id + '"><b>' + comment.author.name + '</b></a>: ' + comment.commentText + '</div>';

				$('#commentDetails .comments').append(html);
			}).bind('ajax:error', function (evt, xhr, status, error) {

				var errors, errorText;

				try {
					errors = $.parseJSON(xhr.responseText);
				} catch (err) {
					errors = {message:'Please reload the page and try again'};
				}

				errorText = 'There were errors with the submission: <ul>';

				for (error in errors)
					errorText += '<li>' + error + ': ' + errors[error] + '</li>';

				errorText += '</ul>';

				$('#new_comment_comment .errors').html(errorText);
			});
		}
		
		function initButtons() {
			
			$('#commentAddition').click(function() {
			
				if ($(this).hasClass('disable')) {
					$('table#highlitedCode div.highlight pre').selectable('destroy');
					$(this).removeClass('disable').html('Enable comment addition');
				} else {
					makeSelectable();
					$(this).addClass('disable').html('Disable comment addition');
				}
			});
			
			$('#commentDetails a#closeCommentBox').click(function (e) {
				e.preventDefault();
				$('#commentDetails').hide();
				var scr = document.body.scrollTop;
				location.hash = '#';
				document.body.scrollTop = scr;
				codeDeselection();
			});
		}
		
		function initDialogs() {
			
			$('#newComment, #editComment').dialog({
				autoOpen: false,
				modal: true,
				width: 600,
				resizable: false,
				draggable: false,
				beforeClose: function (event, ui) {
					$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
				}
			});
		}
		
		function initRest() {
			
			$('#old_comments').height($('#codeContainer').height());

			$('#showCommentedCode').click(function(e) {
				e.preventDefault();
				
				if ($('#commentDetails .comment pre').is(':hidden')) {
					$('#showCommentedCode').html('Hide code');
					$('#commentDetails .comment pre').show(500);
				} else {
					$('#showCommentedCode').html('Show code');
					$('#commentDetails .comment pre').hide(500);
				}
			});

			$(window).keydown(function (e) {
				if (e.keyCode == 17 || e.keyCode == 27)
					$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
			});

			if (location.hash != '') {

				var parts = location.hash.split('_');

				if (parts[0] == '#comment')
					$('.comment[data-id=' + parts[1] + ']').click();
			}
		}
		
		function init() {
			
			if ($('table#highlitedCode div.highlight pre div.line').length) {
				
				makeSelectable();
				
				initComments(true);
				initAddition();
				initEdit();
				
				initCommenting();
				initButtons();
				
				initDialogs();
				initRest();
			}
		}
		
		return {
			init: init
		}
	}
	
	var scrollActive = true;
	var scrollLoading = false;
	var page = 1;

	function loadNextPage(element) {

		if (scrollActive) {
			scrollLoading = true;

			$.get(location.href + '?page=' + (page+1), function(data) {

				if ($.trim(data) != '') {
					$(element).append(data);
					page++;
					scrollLoading = false;
				} else
					scrollActive = false;
			}, 'html');
		}
	}
	
	function isLoading() {
		return scrollLoading;
	}
	
	function init() {
		
		defaultLinkBehaviour();
		tabs();
		taskHistoryDescription();
		deployment();
		
		insertLines('table#highlitedCode.diff');
		insertLines('table#highlitedCode2.diff');
		
		var cr = CodeReview();
		cr.init();
	}
	
	return {
		init: init,
		nextPage: loadNextPage,
		isLoading: isLoading
	}
};

$(document).ready(function() {
	cw = Codewatch();
	cw.init();
});
