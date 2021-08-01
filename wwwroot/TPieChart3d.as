/* // <--

	* This script is freeware and can be used without any restrictions.
	* Junioronline Inc. cannot be held responsible for any damages done using this script.
	* It comes with no warranty.

	* http://downloads.junioronline.us

        * (c) Junioronline Inc.     .:ijf:
                                  ,jGW###W,
                                ;D#####KGt.
                               tW###WGt:
                              f####f,
                       :::. .j####j
                     ,G###G.tK###L.
                     iE##Wf.G###K,
                     ,ijjt.:K###L
                    :K###D.t###W;
                    t####L.G###E:
                   .D####i:K###f .,,,.
                   t####E:;W##W;.G###i
                  ,K####t :jLLt  ifLf:
                 .G####D.
                ;D####D:    
            :iLE####Kt:     * Current script: 	"TPieChart3d.as"
          :GW#####WG;
          ,W##WKGt;         * Written:		September 22 2003 @ 12:52 AM
           ;;,.		    	* By:			Fex

			    			* Version:		1.0
			    			* Description:	TPieChart3d class, is an extension to the
											TPieChart class. This adds in the following
											features: "Gradient", "Depth" and "Height"
											Making it very 3d looking
											
						    * Dependancies: "TChart.as" - v1.1
											"TPieChart.as"
											"TPoint.as"
											"color.as" 

*/ // -->

class TPieChart3d extends TPieChart
{
	// Includes
	#include "color.as"
	
	// Publics
	var DrawLines: Boolean = true;
	var Gradient: Boolean = true;
	var DarkCol: Number = -50;
	var Center: TPoint;
	var Height: Number = 20;
	var Depth: Number = 0.5;
	var colors;
	
	// Constructor
	function TPieChart3d()
	{
		// Call the TChart constructor
		super(arguments[0]);
		
		// Save arguments if specified
		if (arguments[1]) Radius = arguments[1];
		if (arguments[2]) Height = arguments[2];
		if (arguments[3]) Depth  = arguments[3];
		
		// Default center
		Center = new TPoint(0, 0);
	}
	
	// Function that draws a "Slice" of Pie :)
	private function drawSlice ($col, $description, $value, $offset): Void
	{
		var Points = new Array();
		var D_col  = $col;
		
		// If we want to draw a gradient add 
		if (Gradient) D_col = HexAddBrightness($col, DarkCol);
		
		// Loop past each degree
		for (var a=0; a<=$value+1; a++)
		{
			// Calculate targets
			var t  = a + $offset;
			if (t > 360) t = 360;

			var ax = Math.cos(t * RAD) * Radius;
			var ay = Math.sin(t * RAD) * (Radius * Depth);
			
			// Push points into Points Array
			Points.push(new TPoint(ax, ay));
		}

		// Start xy
		var sx 		= Points[0].x;
		var sy 		= Points[0].y;
		
		// End xy
		var ex 		= Points[Points.length-1].x;
		var ey 		= Points[Points.length-1].y;
			
		if ($description)
		{
			var SliceContainer = Container[$description];
			SliceContainer.onRelease = function ()
			{
				trace ($description);
			}
		}
		// If we should draw a Gradient Pie
		if (Gradient) 
			// Set Gradient fillstyle
			SliceContainer.beginGradientFill
			( 
				"radial", 
				[$col, D_col], 
				[100, 100], 
				[0, 255], 
				{matrixType:"box", x:-Radius, y:-(Radius*Depth), w:Radius*2, h:(Radius*2)*Depth, r:0 }
			)
		// Otherwise set regular linestyle
		else SliceContainer.beginFill($col, 100);
						
		// Setup a lineSyle if we should
		if (DrawLines) SliceContainer.lineStyle(0);
		
		// Move to the center
		SliceContainer.moveTo(Center.x, Center.y);
		
		// Line to the start point of the current Pie
		SliceContainer.lineTo(sx, sy);
		
		// If we have height, and we start at zero, draw the height aswell
		if (Height && Math.ceil(sy) >= 0) SliceContainer.lineTo(sx, sy + Height);
		
		// Loop through all the points and draw the curve
		for (var i=1; i<Points.length; i++)
		{
			// Store coordinates of current Point
			var nx = Points[i].x;
			var ny = Points[i].y;
			
			// If we have height, and y is higher then zero, increase the y
			if (Height && Math.ceil(ny) >= 0) ny += Height;
			
			// Draw the line
			SliceContainer.lineTo(nx, ny);
		}
			
		// Draw a line to the end of the current slice
		SliceContainer.lineTo(ex, ey);
	
		// LineTo the center and endFill
		SliceContainer.lineTo(Center.x, Center.y);
		SliceContainer.endFill();
	}
}