package match;

public class Point {

	private double x;
	private double y;
	private long timestamp;
	
	public Point() {
		
	}

	@Override
	public String toString() {
		return "{pos=" + x + ", " + y + ", timestamp=" + timestamp + "\n}";
	}

	public double getX() {
		return x;
	}

	public void setX(double x) {
		this.x = x;
	}

	public double getY() {
		return y;
	}

	public void setY(double y) {
		this.y = y;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
}
