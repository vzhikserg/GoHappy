package match;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class Generator {

	public static void main(String[] args) {
		double THRESHOLD_DISTANCE = 3.254467684583969E-5; //evaluate correct threshold

		String readFile = readFile("sample/bus1.gpx");
		List<Point> bus1Track = xmlParse(readFile);

		String readFile4 = readFile("sample/bus2.gpx");
		List<Point> bus2Track = xmlParse(readFile4);

		String readFile3 = readFile("sample/otherbus.gpx");
		List<Point> wrongButNearbyBus = xmlParse(readFile3);

		String readFile2 = readFile("sample/user.gpx");
		List<Point> userTrack = xmlParse(readFile2);

		// addRandomizedTimestamps(Arrays.asList(busTrack, userTrack,
		// wrongButNearbyBus), startTimestamp, 8 * 60);

		List<List<Point>> liveDatabase = Arrays.asList(bus1Track, bus2Track, wrongButNearbyBus);

		List<Point> myTrack = new ArrayList<>();
		for (Point up : userTrack) {
			myTrack.add(up);

			List<Point> liveUserTrack = new ArrayList<>(myTrack);
			Collections.reverse(liveUserTrack);
			
			System.out.println("Go with point count: " + liveUserTrack.size());

			for (List<Point> track : liveDatabase) {

				boolean matchThisTrack = false;
				LinkedList<Double> errorOfLastX = new LinkedList<>();
				int x = 6;
				Point startingPoint = null;
				double averageError = 0;

				for (Point a : liveUserTrack) {
					Point b = linearApproximation(track, a.getTimestamp());
					double squaredDistance = squaredDistance(a, b);

					errorOfLastX.addFirst(squaredDistance);
					if (errorOfLastX.size() > x)
						errorOfLastX.removeLast();

					double sumError = 0;
					for (Double error : errorOfLastX) {
						sumError += error;
					}
					averageError = sumError / errorOfLastX.size();

					if (errorOfLastX.size() >= x - 2 && averageError > THRESHOLD_DISTANCE) {
						matchThisTrack = false;
						startingPoint = null;
						break;
					}
					if (errorOfLastX.size() >= x - 1) {
						matchThisTrack = true;
					}
					if (matchThisTrack) {
						if (squaredDistance < THRESHOLD_DISTANCE)
							startingPoint = a;
						if (averageError > THRESHOLD_DISTANCE) {
							break;
						}
					}
				}

				if (matchThisTrack)
					System.out.println("   ------- MATCH HERE ------   ");
				System.out.println("Matched: " + matchThisTrack + " (" + averageError + ") (" + liveUserTrack.get(0) + ")");
				if (startingPoint != null)
					System.out.println("Start at: " + startingPoint.toString());
			}
		}

		System.currentTimeMillis();
	}

	private static void printTrack(List<Point> track) {
		String template = "\n<rtept lat=\"{0}\" lon=\"{1}\" time=\"{2}\">" + "\n<ele>447.6</ele>"
				+ "\n<name>WP02-B</name>" + "\n</rtept>";

		for (Point p : track) {
			String format = MessageFormat.format(template, Double.toString(p.getX()), Double.toString(p.getY()),
					Long.toString(p.getTimestamp()));
			System.out.println(format);
		}
	}

	private static void write(List<Point> bus1Track, int i, int j, long start) {
		Random random = new Random();
		for (Point p : bus1Track) {
			p.setTimestamp(start);
			start += 1000 * (random.nextInt(45) + 10);
		}
	}

	public static double squaredDistance(Point a, Point b) {
		double diffX = a.getX() - b.getX();
		double diffY = a.getY() - b.getY();
		return diffX * diffX + diffY * diffY;
	}

	public static Point linearApproximation(List<Point> track, long timestamp) {
		long offsetUnder = Long.MAX_VALUE;
		long offsetAbove = Long.MAX_VALUE;
		Point pointUnder = track.get(0), pointAbove = track.get(track.size() - 1);

		for (Point point : track) {
			long offset = point.getTimestamp() - timestamp;
			offset = Math.abs(offset);

			if (point.getTimestamp() > timestamp && offset < offsetAbove) {
				offsetAbove = offset;
				pointAbove = point;
			} else if (point.getTimestamp() <= timestamp && offset < offsetUnder) {
				offsetUnder = offset;
				pointUnder = point;
			}
		}

		if (offsetUnder == Long.MAX_VALUE)
			return pointAbove;
		if (offsetAbove == Long.MAX_VALUE)
			return pointUnder;

		long a = pointAbove.getTimestamp() - timestamp;
		long b = pointAbove.getTimestamp() - pointUnder.getTimestamp();

		double ratio = (double) a / (double) b;
		ratio = 1 - ratio;

		double directionX = pointAbove.getX() - pointUnder.getX();
		double directionY = pointAbove.getY() - pointUnder.getY();

		directionX *= ratio;
		directionY *= ratio;

		directionX += pointUnder.getX();
		directionY += pointUnder.getY();

		Point simulatePoint = new Point();
		simulatePoint.setX(directionX);
		simulatePoint.setY(directionY);
		simulatePoint.setTimestamp(timestamp);
		return simulatePoint;
	}

	public static void addRandomizedTimestamps(List<List<Point>> tracks, long startTimestamp, long duration) {
		duration *= 1000;

		for (List<Point> track : tracks) {
			long currentTime = startTimestamp;
			long addingThing = duration / track.size();
			for (Point point : track) {
				point.setTimestamp(currentTime);
				currentTime += addingThing;
			}
		}
	}

	public static List<Point> xmlParse(String readFile) {
		List<Point> points = new ArrayList<>();
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = null;
		try {
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		StringBuilder xmlStringBuilder = new StringBuilder();
		xmlStringBuilder.append(readFile);
		ByteArrayInputStream input = null;
		try {
			input = new ByteArrayInputStream(xmlStringBuilder.toString().getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			Document doc = builder.parse(input);

			NodeList list = doc.getElementsByTagName("rtept");
			for (int i = 0; i < list.getLength(); i++) {
				Node item = list.item(i);
				NamedNodeMap attributes = item.getAttributes();
				String lat = attributes.getNamedItem("lat").getNodeValue();
				String lon = attributes.getNamedItem("lon").getNodeValue();
				Point p = new Point();
				if (attributes.getNamedItem("time") != null) {
					String time = attributes.getNamedItem("time").getNodeValue();
					p.setTimestamp(Long.parseLong(time));
				}

				p.setX(Double.parseDouble(lat));
				p.setY(Double.parseDouble(lon));
				points.add(p);
			}
			return points;
		} catch (SAXException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return points;
	}

	public static String readFile(String file) {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			StringBuilder sb = new StringBuilder();
			String line = br.readLine();

			while (line != null) {
				sb.append(line);
				sb.append(System.lineSeparator());
				line = br.readLine();
			}
			String everything = sb.toString();
			return everything;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return file;
	}
}
