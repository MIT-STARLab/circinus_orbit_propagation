//  Material Include file.
//
//  This file was generated for POV-Ray V3.5 by
//  NOTE: Do *NOT* remove the comment lines containing '$MRY$'.
//        To make Moray not re-export the material, change
//        the '$MRY$' to '$MRX$'.
//


//
// ********  MATERIALS  *******
//



#declare PDB_Tex_CG2 = 
   material  // PDB_Tex_CG2
   {   
         texture { spiral1 3 scale <1, 1, .5>                   //-------------------------------------- 
                   texture_map{ [0.25 pigment{ color rgbf <1,0,0,0.2>} finish { ambient 0.3 diffuse 0.5 specular 0.7266 roughness 0.006139  } ]  
                                [0.25 pigment{ color rgbf <1,1,1,0.2>} finish { ambient 0.3 diffuse 0.5 specular 0.7266 roughness 0.006139  } ]
                                [0.75 pigment{ color rgbf <1,1,1,0.2>} finish { ambient 0.3 diffuse 0.5 specular 0.7266 roughness 0.006139  } ]
                                [0.75 pigment{ color rgbf <1,0,0,0.2>} finish { ambient 0.3 diffuse 0.5 specular 0.7266 roughness 0.006139  } ]
                              } // end of texture_map 
                 } // end of texture -------------------------------------------------------------
}

//  $MRY$: 'PDB_Tex_CG2'


#declare PDB_Tex_CG20 = 
   material  // PDB_Tex_CG2
   {   
      texture
      {      
         pigment
         {
            color rgbf <0.1, 0.4, 0.8 0.6>
         }      
         finish
         {
            ambient 0.3
            diffuse 0.5
            specular 0.7266
            roughness 0.006139
         }
      }
   }


//  $MRY$: 'PDB_Tex_O'


#declare PDB_Tex_O = 
   material  // PDB_Tex_O
   {   
      texture
      {      
         pigment
         {
            color rgb <1.0, 0.3, 0.3>
         }      
         finish
         {
            ambient 0.3
            diffuse 0.5
            specular 0.805733
            roughness 0.006178
         }
      }
   }

#declare PDB_red = 
   material  // PDB_red
   {   
      texture
      {      
         pigment
         {
            color rgb <0.9, 0.1, 0.1>
         }      
         finish
         {
            ambient 0.2 diffuse 0.6 specular 0.7266 roughness 0.006139
         }
      }
   }

#declare PDB_green = 
   material  // PDB_green
   {   
      texture
      {      
         pigment
         {
            color rgb <0.1, 0.9, 0.1>
         }      
         finish
         {
            ambient 0.2 diffuse 0.6 specular 0.7266 roughness 0.006139
         }
      }
   }

#declare PDB_blue = 
   material  // PDB_blue
   {   
      texture
      {      
         pigment
         {
            color rgb <0.1, 0.1, 0.9>
         }      
         finish
         {
            ambient 0.2 diffuse 0.6 specular 0.7266   roughness 0.006139
         }
      }
   }

#declare led = 
   material  // PDB_green
   {   
      texture
      {      
         pigment
         {
            color rgb <0., 1, 0.>
         }      
         finish
         {
            ambient 1
         }
      }
   }

#declare b_red = 
   material  // PDB_red
   {   
      texture
      {      
         pigment
         {
            color rgbt <0.9, 0.1, 0.1, 0.0>
         }      
         finish
         {
            ambient 0.1  diffuse 0.8   specular 0.7266   roughness 0.006139
         }
      }
   }

#declare b_green = 
   material  // PDB_green
   {   
      texture
      {      
         pigment
         {
            color rgbt <0.1, 0.9, 0.1, 0.0>
         }      
         finish
         {
            ambient 0.1   diffuse 0.8   specular 0.7266   roughness 0.006139
         }
      }
   }

#declare b_blue = 
   material  // PDB_blue
   {   
      texture
      {      
         pigment
         {
            color rgbt <0.1, 0.1, 0.9, 0.0>
         }      
         finish
         {
            ambient 0.1   diffuse 0.8   specular 0.7266   roughness 0.006139
         }
      }
   }

#declare b_yellow = 
   material  // b_yellow
   {   
      texture
      {      
         pigment
         {
            color rgbt <0.9, 0.9, 0.1, 0.1>
         }      
         finish
         {
            ambient 0.1   diffuse 0.8   specular 0.7266   roughness 0.006139
         }
      }
   }

#declare mcone1 = 
   material  // Material1
   {   
      texture
      {      
         pigment
         {
            radial
            color_map
            {
               [ 0.0     rgbft <0.0, 0.8, 0.8, 0.0, 0.3> ]
               [ 0.5     rgbft <0.0, 0.8, 0.8, 0.0, 0.3> ]
               [ 0.5     rgbft <0.8, 0.8, 0.1, 0.0, 0.3> ]
               [ 1.0     rgbft <0.8, 0.8, 0.1, 0.0, 0.3> ]
            }
            frequency 8
            rotate -90*x
         }      
         finish
         {
            ambient 0.3
            diffuse 0.5
         }
      }
   }
   
   #declare mcone2 = 
   material  // Material1
   {   
      texture
      {      
         pigment
         {
            radial
            color_map
            {
               [ 0.0     rgbft <0.8, 0.0, 0.8, 0.0, 0.3> ]
               [ 0.5     rgbft <0.8, 0.0, 0.8, 0.0, 0.3> ]
               [ 0.5     rgbft <0.0, 0.8, 0.1, 0.0, 0.3> ]
               [ 1.0     rgbft <0.0, 0.8, 0.1, 0.0, 0.3> ]
            }
            frequency 8
            rotate -90*x
         }      
         finish
         {
            ambient 0.3
            diffuse 0.5
         }
      }
   }