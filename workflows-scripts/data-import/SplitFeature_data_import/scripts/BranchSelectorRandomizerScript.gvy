	import java.util.Random;
	
	class Distribution {
	 private Random rnd = new Random();
	 private int[] probs;
	
	 public static Distribution distrFromString(String probs) {

	  def ps = probs.split("-");
	  int[] iprobs = new int[ps.length];
	  int i = 0;
	  for(String sprob : ps) {

	   iprobs[i++] = Integer.parseInt(sprob.trim());
	}

	  return new Distribution(iprobs);
	 }
	
	 Distribution(int[] probs) {
	  this.probs = probs; 
	 }

	 private int next() {
	  int r = 0, i = -1;
	  int rnd = rnd.nextInt(100) + 1;
	  while(r < rnd && i < probs.length) {
	   r += probs[++i];
	  }
	  return i;
	 }
	
	 public String toString() {
	  Integer.toString(next());
	 }
	}

	try{

	vars.putObject("distribution", Distribution.distrFromString(Parameters).toString());
    	vars.put("isFailed","false");
	
	} catch (Exception ex){

		vars.put("ExceptionMessage",ex.getMessage());
		vars.put("isFailed","true");
	}
