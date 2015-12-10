module Plugin

import Flint;
import ParseTree;
import util::IDE;
import Resolve;
import vis::Render;
import Visualize;

anno rel[loc,loc, str] Tree@hyperlinks;


void main() {
  registerLanguage("Flint", "flint", start[Main](str src, loc org) {
    return parse(#start[Main], src, org);
  });
  
  contribs = {
    annotator(Tree(Tree pt) {
      if (start[Main] f := pt) {
        <msgs, hlinks> = resolve(f);
        return pt[@hyperlinks=hlinks][@messages=msgs];
      }
      return pt[@messages={error("BUG: not a form", pt@\loc)}];
    }),
    
    popup(
      menu("Flint",[
        action("Visualize...", (Tree tree, loc source) {
          if (start[Main] flint := tree) {
            render(visualize(flint));
          }
        })
      ])
    )
    
  };
  
  registerContributions("Flint", contribs);
}
