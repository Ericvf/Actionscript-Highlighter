<style>
	.HL_text {
		text-decoration: normal;
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 10px;
	}

	.HL_bcomment {
		color: #878787;
	}

	.HL_comment {
		color: #878787;
	}

	.HL_quote {
		color: #0000FF;
	}

	.HL_keyword {
		color: #000087;
	}

	.HL_identifier {
		color: #000087;
	}

	.HL_property {
		color: #000087;
	}
</style>
<?php

error_reporting(E_ERROR | E_PARSE); // :/
include_once("highlighter.php");

$actionScriptHighlighter = new AS_HIGHLIGHTER();
$proto = $actionScriptHighlighter->HIGHLIGHT_FILE("TPieChart3d.as");

echo "<pre>" . $proto . "</pre>";